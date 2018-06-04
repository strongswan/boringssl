# Note that some host libraries have the same module name as the target
# libraries. This is currently needed to build, for example, adb. But it's
# probably something that should be changed.

LOCAL_PATH := $(call my-dir)

## libcrypto

# Target static library
include $(CLEAR_VARS)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libcrypto_static
LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_PATH)/src/include
LOCAL_ADDITIONAL_DEPENDENCIES := $(LOCAL_PATH)/Android.mk $(LOCAL_PATH)/crypto-sources.mk
LOCAL_SDK_VERSION := 9
LOCAL_CFLAGS += -fvisibility=hidden -DBORINGSSL_SHARED_LIBRARY -DBORINGSSL_IMPLEMENTATION -DOPENSSL_SMALL -Wno-unused-parameter
# sha256-armv4.S does not compile with clang.
ifneq ($(filter $(TARGET_ARCH_ABI), armeabi-v7a arm64-v8a),)
	LOCAL_ASFLAGS += -no-integrated-as
endif
ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
	LOCAL_ASFLAGS += -march=armv8-a+crypto
endif
include $(LOCAL_PATH)/crypto-sources.mk
include $(BUILD_STATIC_LIBRARY)
