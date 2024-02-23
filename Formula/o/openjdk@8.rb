class OpenjdkAT8 < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://github.com/openjdk/jdk8u/archive/refs/tags/jdk8u402-ga.tar.gz"
  version "1.8.0-402"
  sha256 "4e7495914ca02ef8e3d467d0026ff76672891b4ba026b4200aeb9a0666e22238"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^jdk(8u\d+)-ga$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.gsub("8u", "1.8.0+") }.compact
    end
  end

  bottle do
    sha256 cellar: :any,                 ventura:      "82fd20d5c65baa2ad9c55dc3b86e58b98cd84f6985f20264f42f669b20c17a4a"
    sha256 cellar: :any,                 monterey:     "8d3cdf730a56ed24a77b5a7575fa44362e28b4289792979ec07ed2d3af113124"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "79c0a01d0200573d02cba7cb36bcb3179f128a18e812aa74f9a05f5ebbdac031"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on arch: :x86_64
  depends_on "freetype"
  depends_on "giflib"

  uses_from_macos "cups"
  uses_from_macos "unzip"
  uses_from_macos "zip"

  on_monterey :or_newer do
    depends_on "gawk" => :build
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "fontconfig"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxrandr"
    depends_on "libxrender"
    depends_on "libxt"
    depends_on "libxtst"
  end

  # Oracle doesn't serve JDK 7 downloads anymore, so we use Zulu JDK 7 for bootstrapping.
  # https://www.azul.com/downloads/?version=java-7-lts&package=jdk
  resource "boot-jdk" do
    on_macos do
      url "https://cdn.azul.com/zulu/bin/zulu7.56.0.11-ca-jdk7.0.352-macosx_x64.tar.gz"
      sha256 "31909aa6233289f8f1d015586825587e95658ef59b632665e1e49fc33a2cdf06"
    end
    on_linux do
      url "https://cdn.azul.com/zulu/bin/zulu7.56.0.11-ca-jdk7.0.352-linux_x64.tar.gz"
      sha256 "8a7387c1ed151474301b6553c6046f865dc6c1e1890bcf106acc2780c55727c8"
    end
  end

  patch :DATA

  def install
    _, _, update = version.to_s.rpartition("-")
    boot_jdk = buildpath/"boot-jdk"
    resource("boot-jdk").stage boot_jdk
    java_options = ENV.delete("_JAVA_OPTIONS")

    # Work around clashing -I/usr/include and -isystem headers,
    # as superenv already handles this detail for us.
    inreplace "common/autoconf/flags.m4",
              '-isysroot \"$SYSROOT\"', ""
    inreplace "common/autoconf/toolchain.m4",
              '-isysroot \"$SDKPATH\" -iframework\"$SDKPATH/System/Library/Frameworks\"', ""
    inreplace "hotspot/make/bsd/makefiles/saproc.make",
              '-isysroot "$(SDKPATH)" -iframework"$(SDKPATH)/System/Library/Frameworks"', ""

    if OS.mac?
      # Fix macOS version detection. After 10.10 this was changed to a 6 digit number,
      # but this Makefile was written in the era of 4 digit numbers.
      inreplace "hotspot/make/bsd/makefiles/gcc.make" do |s|
        s.gsub! "$(subst .,,$(MACOSX_VERSION_MIN))", ENV["HOMEBREW_MACOS_VERSION_NUMERIC"]
        s.gsub! "MACOSX_VERSION_MIN=10.7.0", "MACOSX_VERSION_MIN=#{MacOS.version}"
      end

      # Fix Xcode 13 detection.
      # inreplace "common/autoconf/toolchain.m4",
      #           "if test \"${XC_VERSION_PARTS[[0]]}\" != \"6\"",
      #           "if test \"${XC_VERSION_PARTS[[0]]}\" != \"#{MacOS::Xcode.version.major}\""
    else
      # Fix linker errors on brewed GCC
      inreplace "common/autoconf/flags.m4", "-Xlinker -O1", ""
      inreplace "hotspot/make/linux/makefiles/gcc.make", "-Xlinker -O1", ""
    end

    args = %W[
      --with-boot-jdk-jvmargs=#{java_options}
      --with-boot-jdk=#{boot_jdk}
      --with-debug-level=release
      --with-conf-name=release
      --with-jvm-variants=server
      --with-milestone=fcs
      --with-native-debug-symbols=none
      --with-update-version=#{update}
      --with-vendor-bug-url=#{tap.issues_url}
      --with-vendor-name=#{tap.user}
      --with-vendor-url=#{tap.issues_url}
      --with-vendor-vm-bug-url=#{tap.issues_url}
      --with-giflib=system
    ]

    ldflags = ["-Wl,-rpath,#{loader_path.gsub("$", "\\$$$$")}/server"]
    if OS.mac?
      args += %w[
        --with-toolchain-type=clang
        --with-zlib=system
      ]

      # Work around SDK issues with JavaVM framework.
      if MacOS.version <= :catalina
        sdk_path = MacOS::CLT.sdk_path(MacOS.version)
        ENV["SDKPATH"] = ENV["SDKROOT"] = sdk_path
        javavm_framework_path = sdk_path/"System/Library/Frameworks/JavaVM.framework/Frameworks"
        args += %W[
          --with-extra-cflags=-F#{javavm_framework_path}
          --with-extra-cxxflags=-F#{javavm_framework_path}
        ]
        ldflags << "-F#{javavm_framework_path}"
      end
    else
      args += %W[
        --with-toolchain-type=gcc
        --x-includes=#{HOMEBREW_PREFIX}/include
        --x-libraries=#{HOMEBREW_PREFIX}/lib
        --with-cups=#{HOMEBREW_PREFIX}
        --with-fontconfig=#{HOMEBREW_PREFIX}
        --with-stdc++lib=dynamic
      ]
      extra_rpath = rpath(source: libexec/"lib/amd64", target: libexec/"jre/lib/amd64")
      ldflags << "-Wl,-rpath,#{extra_rpath.gsub("$", "\\$$$$")}"
    end
    args << "--with-extra-ldflags=#{ldflags.join(" ")}"

    system "bash", "common/autoconf/autogen.sh"
    system "bash", "configure", *args

    ENV["MAKEFLAGS"] = "JOBS=#{ENV.make_jobs}"
    system "make", "bootcycle-images", "CONF=release"

    cd "build/release/images" do
      jdk = libexec

      if OS.mac?
        libexec.install Dir["j2sdk-bundle/*"].first => "openjdk.jdk"
        jdk /= "openjdk.jdk/Contents/Home"
      else
        libexec.install Dir["j2sdk-image/*"]
      end

      bin.install_symlink Dir[jdk/"bin/*"]
      include.install_symlink Dir[jdk/"include/*.h"]
      include.install_symlink Dir[jdk/"include/*/*.h"]
      man1.install_symlink Dir[jdk/"man/man1/*"]
    end
  end

  def caveats
    on_macos do
      <<~EOS
        For the system Java wrappers to find this JDK, symlink it with
          sudo ln -sfn #{opt_libexec}/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-8.jdk
      EOS
    end
  end

  test do
    (testpath/"HelloWorld.java").write <<~EOS
      class HelloWorld {
        public static void main(String args[]) {
          System.out.println("Hello, world!");
        }
      }
    EOS

    system bin/"javac", "HelloWorld.java"

    assert_match "Hello, world!", shell_output("#{bin}/java HelloWorld")
  end
end

__END__
Subject: [PATCH] Fixed C++11 build failure issue
---
Index: hotspot/src/os/bsd/vm/os_perf_bsd.cpp
<+>UTF-8
===================================================================
diff --git a/hotspot/src/os/bsd/vm/os_perf_bsd.cpp b/hotspot/src/os/bsd/vm/os_perf_bsd.cpp
--- a/hotspot/src/os/bsd/vm/os_perf_bsd.cpp	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/hotspot/src/os/bsd/vm/os_perf_bsd.cpp	(date 1708511091537)
@@ -26,7 +26,9 @@
 #include "memory/resourceArea.hpp"
 #include "runtime/os.hpp"
 #include "runtime/os_perf.hpp"
+#if defined(X86) && !defined(ZERO)
 #include "vm_version_ext_x86.hpp"
+#endif
 
 #ifdef __APPLE__
   #import <libproc.h>
@@ -374,11 +376,13 @@
   if (NULL == _cpu_info) {
     return false;
   }
+#if defined(X86) && !defined(ZERO)
   _cpu_info->set_number_of_hardware_threads(VM_Version_Ext::number_of_threads());
   _cpu_info->set_number_of_cores(VM_Version_Ext::number_of_cores());
   _cpu_info->set_number_of_sockets(VM_Version_Ext::number_of_sockets());
   _cpu_info->set_cpu_name(VM_Version_Ext::cpu_name());
   _cpu_info->set_cpu_description(VM_Version_Ext::cpu_description());
+#endif
 
   return true;
 }
Index: common/autoconf/flags.m4
<+>UTF-8
===================================================================
diff --git a/common/autoconf/flags.m4 b/common/autoconf/flags.m4
--- a/common/autoconf/flags.m4	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/common/autoconf/flags.m4	(date 1708585970499)
@@ -705,6 +705,10 @@
       # command line.
       CCXXFLAGS_JDK="$CCXXFLAGS_JDK -DMAC_OS_X_VERSION_MAX_ALLOWED=\$(subst .,,\$(MACOSX_VERSION_MIN)) -mmacosx-version-min=\$(MACOSX_VERSION_MIN)"
       LDFLAGS_JDK="$LDFLAGS_JDK -mmacosx-version-min=\$(MACOSX_VERSION_MIN)"
+      if test "$OPENJDK_TARGET_CPU_ARCH" = "xaarch64"; then
+        CFLAGS_JDK="${CFLAGS_JDK} -arch arm64"
+        LDFLAGS_JDK="${LDFLAGS_JDK} -arch arm64"
+      fi
     fi
   fi
 
Index: hotspot/src/share/vm/utilities/globalDefinitions_gcc.hpp
<+>UTF-8
===================================================================
diff --git a/hotspot/src/share/vm/utilities/globalDefinitions_gcc.hpp b/hotspot/src/share/vm/utilities/globalDefinitions_gcc.hpp
--- a/hotspot/src/share/vm/utilities/globalDefinitions_gcc.hpp	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/hotspot/src/share/vm/utilities/globalDefinitions_gcc.hpp	(date 1708512777950)
@@ -249,8 +249,8 @@
 
 // Checking for finiteness
 
-inline int g_isfinite(jfloat  f)                 { return finite(f); }
-inline int g_isfinite(jdouble f)                 { return finite(f); }
+inline int g_isfinite(jfloat  f)                 { return isfinite(f); }
+inline int g_isfinite(jdouble f)                 { return isfinite(f); }
 
 
 // Wide characters
Index: hotspot/src/os_cpu/linux_zero/vm/os_linux_zero.cpp
<+>UTF-8
===================================================================
diff --git a/hotspot/src/os_cpu/linux_zero/vm/os_linux_zero.cpp b/hotspot/src/os_cpu/linux_zero/vm/os_linux_zero.cpp
--- a/hotspot/src/os_cpu/linux_zero/vm/os_linux_zero.cpp	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/hotspot/src/os_cpu/linux_zero/vm/os_linux_zero.cpp	(date 1708512257136)
@@ -412,42 +412,42 @@
   }
 
 
-  void _Copy_conjoint_jshorts_atomic(jshort* from, jshort* to, size_t count) {
+  void _Copy_conjoint_jshorts_atomic(const jshort* from, jshort* to, size_t count) {
     if (from > to) {
-      jshort *end = from + count;
+      const jshort *end = from + count;
       while (from < end)
         *(to++) = *(from++);
     }
     else if (from < to) {
-      jshort *end = from;
+      const jshort *end = from;
       from += count - 1;
       to   += count - 1;
       while (from >= end)
         *(to--) = *(from--);
     }
   }
-  void _Copy_conjoint_jints_atomic(jint* from, jint* to, size_t count) {
+  void _Copy_conjoint_jints_atomic(const jint* from, jint* to, size_t count) {
     if (from > to) {
-      jint *end = from + count;
+      const jint *end = from + count;
       while (from < end)
         *(to++) = *(from++);
     }
     else if (from < to) {
-      jint *end = from;
+      const jint *end = from;
       from += count - 1;
       to   += count - 1;
       while (from >= end)
         *(to--) = *(from--);
     }
   }
-  void _Copy_conjoint_jlongs_atomic(jlong* from, jlong* to, size_t count) {
+void _Copy_conjoint_jlongs_atomic(const jlong* from, jlong* to, size_t count) {
     if (from > to) {
-      jlong *end = from + count;
+      const jlong *end = from + count;
       while (from < end)
         os::atomic_copy64(from++, to++);
     }
     else if (from < to) {
-      jlong *end = from;
+      const jlong *end = from;
       from += count - 1;
       to   += count - 1;
       while (from >= end)
@@ -455,22 +455,22 @@
     }
   }
 
-  void _Copy_arrayof_conjoint_bytes(HeapWord* from,
+  void _Copy_arrayof_conjoint_bytes(const HeapWord* from,
                                     HeapWord* to,
                                     size_t    count) {
     memmove(to, from, count);
   }
-  void _Copy_arrayof_conjoint_jshorts(HeapWord* from,
+  void _Copy_arrayof_conjoint_jshorts(const HeapWord* from,
                                       HeapWord* to,
                                       size_t    count) {
     memmove(to, from, count * 2);
   }
-  void _Copy_arrayof_conjoint_jints(HeapWord* from,
+  void _Copy_arrayof_conjoint_jints(const HeapWord* from,
                                     HeapWord* to,
                                     size_t    count) {
     memmove(to, from, count * 4);
   }
-  void _Copy_arrayof_conjoint_jlongs(HeapWord* from,
+  void _Copy_arrayof_conjoint_jlongs(const HeapWord* from,
                                      HeapWord* to,
                                      size_t    count) {
     memmove(to, from, count * 8);
Index: common/autoconf/platform.m4
<+>UTF-8
===================================================================
diff --git a/common/autoconf/platform.m4 b/common/autoconf/platform.m4
--- a/common/autoconf/platform.m4	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/common/autoconf/platform.m4	(date 1708584950523)
@@ -43,10 +43,20 @@
       VAR_CPU_ENDIAN=little
       ;;
     arm*)
-      VAR_CPU=arm
-      VAR_CPU_ARCH=arm
-      VAR_CPU_BITS=32
-      VAR_CPU_ENDIAN=little
+      case "$2" in
+        *darwin*)
+          VAR_CPU=aarch64
+          VAR_CPU_ARCH=aarch64
+          VAR_CPU_BITS=64
+          VAR_CPU_ENDIAN=little
+        ;;
+        *)
+          VAR_CPU=arm
+          VAR_CPU_ARCH=arm
+          VAR_CPU_BITS=32
+          VAR_CPU_ENDIAN=little
+        ;;
+      esac
       ;;
     aarch64)
       VAR_CPU=aarch64
@@ -168,7 +178,7 @@
 
   # Convert the autoconf OS/CPU value to our own data, into the VAR_OS/CPU variables.
   PLATFORM_EXTRACT_VARS_FROM_OS($build_os)
-  PLATFORM_EXTRACT_VARS_FROM_CPU($build_cpu)
+  PLATFORM_EXTRACT_VARS_FROM_CPU($build_cpu, $build_os)
   # ..and setup our own variables. (Do this explicitely to facilitate searching)
   OPENJDK_BUILD_OS="$VAR_OS"
   OPENJDK_BUILD_OS_API="$VAR_OS_API"
@@ -190,7 +200,7 @@
 
   # Convert the autoconf OS/CPU value to our own data, into the VAR_OS/CPU variables.
   PLATFORM_EXTRACT_VARS_FROM_OS($host_os)
-  PLATFORM_EXTRACT_VARS_FROM_CPU($host_cpu)
+  PLATFORM_EXTRACT_VARS_FROM_CPU($host_cpu, $host_os)
   # ... and setup our own variables. (Do this explicitely to facilitate searching)
   OPENJDK_TARGET_OS="$VAR_OS"
   OPENJDK_TARGET_OS_API="$VAR_OS_API"
Index: hotspot/src/share/vm/runtime/virtualspace.cpp
<+>UTF-8
===================================================================
diff --git a/hotspot/src/share/vm/runtime/virtualspace.cpp b/hotspot/src/share/vm/runtime/virtualspace.cpp
--- a/hotspot/src/share/vm/runtime/virtualspace.cpp	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/hotspot/src/share/vm/runtime/virtualspace.cpp	(date 1708587089513)
@@ -356,7 +356,11 @@
 ReservedCodeSpace::ReservedCodeSpace(size_t r_size,
                                      size_t rs_align,
                                      bool large) :
+#ifdef __arm64__
+  ReservedSpace(r_size, rs_align, large, /*executable*/ false) {
+#else
   ReservedSpace(r_size, rs_align, large, /*executable*/ true) {
+#endif
   MemTracker::record_virtual_memory_type((address)base(), mtCode);
 }
 
Index: hotspot/make/bsd/makefiles/gcc.make
<+>UTF-8
===================================================================
diff --git a/hotspot/make/bsd/makefiles/gcc.make b/hotspot/make/bsd/makefiles/gcc.make
--- a/hotspot/make/bsd/makefiles/gcc.make	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/hotspot/make/bsd/makefiles/gcc.make	(date 1708509190657)
@@ -258,6 +258,8 @@
 #  WARNINGS_ARE_ERRORS += -Wno-tautological-constant-out-of-range-compare
   WARNINGS_ARE_ERRORS += -Wno-delete-non-virtual-dtor -Wno-deprecated -Wno-format -Wno-dynamic-class-memaccess
   WARNINGS_ARE_ERRORS += -Wno-empty-body
+  WARNINGS_ARE_ERRORS += -Wno-reserved-user-defined-literal
+  WARNINGS_ARE_ERRORS += -Wno-c++11-narrowing
 endif
 
 WARNING_FLAGS = -Wpointer-arith -Wsign-compare -Wundef -Wunused-function -Wformat=2
Index: common/autoconf/toolchain.m4
<+>UTF-8
===================================================================
diff --git a/common/autoconf/toolchain.m4 b/common/autoconf/toolchain.m4
--- a/common/autoconf/toolchain.m4	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/common/autoconf/toolchain.m4	(date 1708510025306)
@@ -290,8 +290,8 @@
     # Fail-fast: verify we're building on a supported Xcode version
     XCODE_VERSION=`$XCODEBUILD -version | grep '^Xcode ' | sed 's/Xcode //'`
     XC_VERSION_PARTS=( ${XCODE_VERSION//./ } )
-    if test "${XC_VERSION_PARTS[[0]]}" != "6" -a "${XC_VERSION_PARTS[[0]]}" != "9" -a "${XC_VERSION_PARTS[[0]]}" != "10" -a "${XC_VERSION_PARTS[[0]]}" != "11" -a "${XC_VERSION_PARTS[[0]]}" != "12" ; then
-      AC_MSG_ERROR([Xcode 6, 9-12 is required to build JDK 8, the version found was $XCODE_VERSION. Use --with-xcode-path to specify the location of Xcode or make Xcode active by using xcode-select.])
+    if test "${XC_VERSION_PARTS[[0]]}" -lt "3" ; then
+      AC_MSG_ERROR([Xcode 3+ is required to build JDK 8, the version found was $XCODE_VERSION. Use --with-xcode-path to specify the location of Xcode or make Xcode active by using xcode-select.])
     fi
 
     # Some versions of Xcode command line tools install gcc and g++ as symlinks to
Index: hotspot/src/os_cpu/bsd_x86/vm/os_bsd_x86.cpp
<+>UTF-8
===================================================================
diff --git a/hotspot/src/os_cpu/bsd_x86/vm/os_bsd_x86.cpp b/hotspot/src/os_cpu/bsd_x86/vm/os_bsd_x86.cpp
--- a/hotspot/src/os_cpu/bsd_x86/vm/os_bsd_x86.cpp	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/hotspot/src/os_cpu/bsd_x86/vm/os_bsd_x86.cpp	(date 1708509033688)
@@ -281,11 +281,11 @@
 address os::current_stack_pointer() {
 #if defined(__clang__) || defined(__llvm__)
   register void *esp;
-  __asm__("mov %%"SPELL_REG_SP", %0":"=r"(esp));
+  __asm__("mov %%" SPELL_REG_SP ", %0":"=r"(esp));
   return (address) esp;
 #elif defined(SPARC_WORKS)
   register void *esp;
-  __asm__("mov %%"SPELL_REG_SP", %0":"=r"(esp));
+  __asm__("mov %%" SPELL_REG_SP ", %0":"=r"(esp));
   return (address) ((char*)esp + sizeof(long)*2);
 #else
   register void *esp __asm__ (SPELL_REG_SP);
@@ -368,7 +368,7 @@
 intptr_t* _get_previous_fp() {
 #if defined(SPARC_WORKS) || defined(__clang__) || defined(__llvm__)
   register intptr_t **ebp;
-  __asm__("mov %%"SPELL_REG_FP", %0":"=r"(ebp));
+  __asm__("mov %%" SPELL_REG_FP ", %0":"=r"(ebp));
 #else
   register intptr_t **ebp __asm__ (SPELL_REG_FP);
 #endif
Index: hotspot/src/share/vm/runtime/sharedRuntime.cpp
<+>UTF-8
===================================================================
diff --git a/hotspot/src/share/vm/runtime/sharedRuntime.cpp b/hotspot/src/share/vm/runtime/sharedRuntime.cpp
--- a/hotspot/src/share/vm/runtime/sharedRuntime.cpp	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/hotspot/src/share/vm/runtime/sharedRuntime.cpp	(date 1708512397473)
@@ -108,12 +108,14 @@
 
 //----------------------------generate_stubs-----------------------------------
 void SharedRuntime::generate_stubs() {
+#ifndef ZERO
   _wrong_method_blob                   = generate_resolve_blob(CAST_FROM_FN_PTR(address, SharedRuntime::handle_wrong_method),          "wrong_method_stub");
   _wrong_method_abstract_blob          = generate_resolve_blob(CAST_FROM_FN_PTR(address, SharedRuntime::handle_wrong_method_abstract), "wrong_method_abstract_stub");
   _ic_miss_blob                        = generate_resolve_blob(CAST_FROM_FN_PTR(address, SharedRuntime::handle_wrong_method_ic_miss),  "ic_miss_stub");
   _resolve_opt_virtual_call_blob       = generate_resolve_blob(CAST_FROM_FN_PTR(address, SharedRuntime::resolve_opt_virtual_call_C),   "resolve_opt_virtual_call");
   _resolve_virtual_call_blob           = generate_resolve_blob(CAST_FROM_FN_PTR(address, SharedRuntime::resolve_virtual_call_C),       "resolve_virtual_call");
   _resolve_static_call_blob            = generate_resolve_blob(CAST_FROM_FN_PTR(address, SharedRuntime::resolve_static_call_C),        "resolve_static_call");
+#endif
 
 #ifdef COMPILER2
   // Vectors are generated only by C2.
@@ -2384,7 +2386,12 @@
   // throw AbstractMethodError just in case.
   // Pass wrong_method_abstract for the c2i transitions to return
   // AbstractMethodError for invalid invocations.
-  address wrong_method_abstract = SharedRuntime::get_handle_wrong_method_abstract_stub();
+  address wrong_method_abstract =
+#ifdef ZERO
+                                  NULL;
+#else
+                                  SharedRuntime::get_handle_wrong_method_abstract_stub();
+#endif
   _abstract_method_handler = AdapterHandlerLibrary::new_entry(new AdapterFingerPrint(0, NULL),
                                                               StubRoutines::throw_AbstractMethodError_entry(),
                                                               wrong_method_abstract, wrong_method_abstract);
Index: hotspot/src/share/vm/compiler/compileBroker.cpp
<+>UTF-8
===================================================================
diff --git a/hotspot/src/share/vm/compiler/compileBroker.cpp b/hotspot/src/share/vm/compiler/compileBroker.cpp
--- a/hotspot/src/share/vm/compiler/compileBroker.cpp	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/hotspot/src/share/vm/compiler/compileBroker.cpp	(date 1708515681291)
@@ -72,7 +72,7 @@
     Symbol* name = (method)->name();                                     \
     Symbol* signature = (method)->signature();                           \
     HS_DTRACE_PROBE8(hotspot, method__compile__begin,                    \
-      comp_name, strlen(comp_name),                                      \
+      (char *) comp_name, strlen(comp_name),                             \
       klass_name->bytes(), klass_name->utf8_length(),                    \
       name->bytes(), name->utf8_length(),                                \
       signature->bytes(), signature->utf8_length());                     \
@@ -84,7 +84,7 @@
     Symbol* name = (method)->name();                                     \
     Symbol* signature = (method)->signature();                           \
     HS_DTRACE_PROBE9(hotspot, method__compile__end,                      \
-      comp_name, strlen(comp_name),                                      \
+      (char *) comp_name, strlen(comp_name),                             \
       klass_name->bytes(), klass_name->utf8_length(),                    \
       name->bytes(), name->utf8_length(),                                \
       signature->bytes(), signature->utf8_length(), (success));          \
Index: jdk/src/macosx/bin/java_md_macosx.c
<+>UTF-8
===================================================================
diff --git a/jdk/src/macosx/bin/java_md_macosx.c b/jdk/src/macosx/bin/java_md_macosx.c
--- a/jdk/src/macosx/bin/java_md_macosx.c	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/jdk/src/macosx/bin/java_md_macosx.c	(date 1708512620716)
@@ -228,6 +228,8 @@
         preferredJVM = "client";
 #elif defined(__x86_64__)
         preferredJVM = "server";
+#elif defined(__arm64__)
+        preferredJVM = "zero";
 #else
 #error "Unknown architecture - needs definition"
 #endif
Index: hotspot/src/share/vm/prims/jni.cpp
<+>UTF-8
===================================================================
diff --git a/hotspot/src/share/vm/prims/jni.cpp b/hotspot/src/share/vm/prims/jni.cpp
--- a/hotspot/src/share/vm/prims/jni.cpp	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/hotspot/src/share/vm/prims/jni.cpp	(date 1708517004469)
@@ -426,8 +426,7 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, FindClass__entry, env, name);
 #else /* USDT2 */
-  HOTSPOT_JNI_FINDCLASS_ENTRY(
-                              env, (char *)name);
+  HOTSPOT_JNI_FINDCLASS_ENTRY(env, (char *)name);
 #endif /* USDT2 */
 
   jclass result = NULL;
@@ -504,8 +503,7 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, FromReflectedMethod__entry, env, method);
 #else /* USDT2 */
-  HOTSPOT_JNI_FROMREFLECTEDMETHOD_ENTRY(
-                                        env, method);
+  HOTSPOT_JNI_FROMREFLECTEDMETHOD_ENTRY(env, method);
 #endif /* USDT2 */
   jmethodID ret = NULL;
   DT_RETURN_MARK(FromReflectedMethod, jmethodID, (const jmethodID&)ret);
@@ -545,8 +543,7 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, FromReflectedField__entry, env, field);
 #else /* USDT2 */
-  HOTSPOT_JNI_FROMREFLECTEDFIELD_ENTRY(
-                                       env, field);
+  HOTSPOT_JNI_FROMREFLECTEDFIELD_ENTRY(env, field);
 #endif /* USDT2 */
   jfieldID ret = NULL;
   DT_RETURN_MARK(FromReflectedField, jfieldID, (const jfieldID&)ret);
@@ -594,8 +591,7 @@
 #ifndef USDT2
   DTRACE_PROBE4(hotspot_jni, ToReflectedMethod__entry, env, cls, method_id, isStatic);
 #else /* USDT2 */
-  HOTSPOT_JNI_TOREFLECTEDMETHOD_ENTRY(
-                                      env, cls, (uintptr_t) method_id, isStatic);
+  HOTSPOT_JNI_TOREFLECTEDMETHOD_ENTRY(env, cls, (uintptr_t) method_id, isStatic);
 #endif /* USDT2 */
   jobject ret = NULL;
   DT_RETURN_MARK(ToReflectedMethod, jobject, (const jobject&)ret);
@@ -624,8 +620,7 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, GetSuperclass__entry, env, sub);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETSUPERCLASS_ENTRY(
-                                  env, sub);
+  HOTSPOT_JNI_GETSUPERCLASS_ENTRY(env, sub);
 #endif /* USDT2 */
   jclass obj = NULL;
   DT_RETURN_MARK(GetSuperclass, jclass, (const jclass&)obj);
@@ -658,8 +653,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, IsAssignableFrom__entry, env, sub, super);
 #else /* USDT2 */
-  HOTSPOT_JNI_ISASSIGNABLEFROM_ENTRY(
-                                     env, sub, super);
+  HOTSPOT_JNI_ISASSIGNABLEFROM_ENTRY(env, sub, super);
 #endif /* USDT2 */
   oop sub_mirror   = JNIHandles::resolve_non_null(sub);
   oop super_mirror = JNIHandles::resolve_non_null(super);
@@ -669,8 +663,7 @@
 #ifndef USDT2
     DTRACE_PROBE1(hotspot_jni, IsAssignableFrom__return, ret);
 #else /* USDT2 */
-    HOTSPOT_JNI_ISASSIGNABLEFROM_RETURN(
-                                        ret);
+    HOTSPOT_JNI_ISASSIGNABLEFROM_RETURN(ret);
 #endif /* USDT2 */
     return ret;
   }
@@ -682,8 +675,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, IsAssignableFrom__return, ret);
 #else /* USDT2 */
-  HOTSPOT_JNI_ISASSIGNABLEFROM_RETURN(
-                                      ret);
+  HOTSPOT_JNI_ISASSIGNABLEFROM_RETURN(ret);
 #endif /* USDT2 */
   return ret;
 JNI_END
@@ -700,8 +692,7 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, Throw__entry, env, obj);
 #else /* USDT2 */
-  HOTSPOT_JNI_THROW_ENTRY(
- env, obj);
+  HOTSPOT_JNI_THROW_ENTRY(env, obj);
 #endif /* USDT2 */
   jint ret = JNI_OK;
   DT_RETURN_MARK(Throw, jint, (const jint&)ret);
@@ -723,8 +714,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, ThrowNew__entry, env, clazz, message);
 #else /* USDT2 */
-  HOTSPOT_JNI_THROWNEW_ENTRY(
-                             env, clazz, (char *) message);
+  HOTSPOT_JNI_THROWNEW_ENTRY(env, clazz, (char *) message);
 #endif /* USDT2 */
   jint ret = JNI_OK;
   DT_RETURN_MARK(ThrowNew, jint, (const jint&)ret);
@@ -758,8 +748,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, ExceptionOccurred__entry, env);
 #else /* USDT2 */
-  HOTSPOT_JNI_EXCEPTIONOCCURRED_ENTRY(
-                                      env);
+  HOTSPOT_JNI_EXCEPTIONOCCURRED_ENTRY(env);
 #endif /* USDT2 */
   jni_check_async_exceptions(thread);
   oop exception = thread->pending_exception();
@@ -767,8 +756,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, ExceptionOccurred__return, ret);
 #else /* USDT2 */
-  HOTSPOT_JNI_EXCEPTIONOCCURRED_RETURN(
-                                       ret);
+  HOTSPOT_JNI_EXCEPTIONOCCURRED_RETURN(ret);
 #endif /* USDT2 */
   return ret;
 JNI_END
@@ -779,8 +767,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, ExceptionDescribe__entry, env);
 #else /* USDT2 */
-  HOTSPOT_JNI_EXCEPTIONDESCRIBE_ENTRY(
-                                      env);
+  HOTSPOT_JNI_EXCEPTIONDESCRIBE_ENTRY(env);
 #endif /* USDT2 */
   if (thread->has_pending_exception()) {
     Handle ex(thread, thread->pending_exception());
@@ -820,8 +807,7 @@
 #ifndef USDT2
   DTRACE_PROBE(hotspot_jni, ExceptionDescribe__return);
 #else /* USDT2 */
-  HOTSPOT_JNI_EXCEPTIONDESCRIBE_RETURN(
-                                       );
+  HOTSPOT_JNI_EXCEPTIONDESCRIBE_RETURN();
 #endif /* USDT2 */
 JNI_END
 
@@ -831,8 +817,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, ExceptionClear__entry, env);
 #else /* USDT2 */
-  HOTSPOT_JNI_EXCEPTIONCLEAR_ENTRY(
-                                   env);
+  HOTSPOT_JNI_EXCEPTIONCLEAR_ENTRY(env);
 #endif /* USDT2 */
 
   // The jni code might be using this API to clear java thrown exception.
@@ -845,8 +830,7 @@
 #ifndef USDT2
   DTRACE_PROBE(hotspot_jni, ExceptionClear__return);
 #else /* USDT2 */
-  HOTSPOT_JNI_EXCEPTIONCLEAR_RETURN(
-                                    );
+  HOTSPOT_JNI_EXCEPTIONCLEAR_RETURN();
 #endif /* USDT2 */
 JNI_END
 
@@ -856,8 +840,7 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, FatalError__entry, env, msg);
 #else /* USDT2 */
-  HOTSPOT_JNI_FATALERROR_ENTRY(
-                               env, (char *) msg);
+  HOTSPOT_JNI_FATALERROR_ENTRY(env, (char *) msg);
 #endif /* USDT2 */
   tty->print_cr("FATAL ERROR in native method: %s", msg);
   thread->print_stack();
@@ -870,8 +853,7 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, PushLocalFrame__entry, env, capacity);
 #else /* USDT2 */
-  HOTSPOT_JNI_PUSHLOCALFRAME_ENTRY(
-                                   env, capacity);
+  HOTSPOT_JNI_PUSHLOCALFRAME_ENTRY(env, capacity);
 #endif /* USDT2 */
   //%note jni_11
   if (capacity < 0 ||
@@ -879,8 +861,7 @@
 #ifndef USDT2
     DTRACE_PROBE1(hotspot_jni, PushLocalFrame__return, JNI_ERR);
 #else /* USDT2 */
-    HOTSPOT_JNI_PUSHLOCALFRAME_RETURN(
-                                      (uint32_t)JNI_ERR);
+    HOTSPOT_JNI_PUSHLOCALFRAME_RETURN((uint32_t)JNI_ERR);
 #endif /* USDT2 */
     return JNI_ERR;
   }
@@ -893,8 +874,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, PushLocalFrame__return, ret);
 #else /* USDT2 */
-  HOTSPOT_JNI_PUSHLOCALFRAME_RETURN(
-                                    ret);
+  HOTSPOT_JNI_PUSHLOCALFRAME_RETURN(ret);
 #endif /* USDT2 */
   return ret;
 JNI_END
@@ -905,8 +885,7 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, PopLocalFrame__entry, env, result);
 #else /* USDT2 */
-  HOTSPOT_JNI_POPLOCALFRAME_ENTRY(
-                                  env, result);
+  HOTSPOT_JNI_POPLOCALFRAME_ENTRY(env, result);
 #endif /* USDT2 */
   //%note jni_11
   Handle result_handle(thread, JNIHandles::resolve(result));
@@ -925,8 +904,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, PopLocalFrame__return, result);
 #else /* USDT2 */
-  HOTSPOT_JNI_POPLOCALFRAME_RETURN(
-                                   result);
+  HOTSPOT_JNI_POPLOCALFRAME_RETURN(result);
 #endif /* USDT2 */
   return result;
 JNI_END
@@ -937,16 +915,14 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, NewGlobalRef__entry, env, ref);
 #else /* USDT2 */
-  HOTSPOT_JNI_NEWGLOBALREF_ENTRY(
-                                 env, ref);
+  HOTSPOT_JNI_NEWGLOBALREF_ENTRY(env, ref);
 #endif /* USDT2 */
   Handle ref_handle(thread, JNIHandles::resolve(ref));
   jobject ret = JNIHandles::make_global(ref_handle);
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, NewGlobalRef__return, ret);
 #else /* USDT2 */
-  HOTSPOT_JNI_NEWGLOBALREF_RETURN(
-                                  ret);
+  HOTSPOT_JNI_NEWGLOBALREF_RETURN(ret);
 #endif /* USDT2 */
   return ret;
 JNI_END
@@ -957,15 +933,13 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, DeleteGlobalRef__entry, env, ref);
 #else /* USDT2 */
-  HOTSPOT_JNI_DELETEGLOBALREF_ENTRY(
-                                    env, ref);
+  HOTSPOT_JNI_DELETEGLOBALREF_ENTRY(env, ref);
 #endif /* USDT2 */
   JNIHandles::destroy_global(ref);
 #ifndef USDT2
   DTRACE_PROBE(hotspot_jni, DeleteGlobalRef__return);
 #else /* USDT2 */
-  HOTSPOT_JNI_DELETEGLOBALREF_RETURN(
-                                     );
+  HOTSPOT_JNI_DELETEGLOBALREF_RETURN();
 #endif /* USDT2 */
 JNI_END
 
@@ -974,15 +948,13 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, DeleteLocalRef__entry, env, obj);
 #else /* USDT2 */
-  HOTSPOT_JNI_DELETELOCALREF_ENTRY(
-                                   env, obj);
+  HOTSPOT_JNI_DELETELOCALREF_ENTRY(env, obj);
 #endif /* USDT2 */
   JNIHandles::destroy_local(obj);
 #ifndef USDT2
   DTRACE_PROBE(hotspot_jni, DeleteLocalRef__return);
 #else /* USDT2 */
-  HOTSPOT_JNI_DELETELOCALREF_RETURN(
-                                    );
+  HOTSPOT_JNI_DELETELOCALREF_RETURN();
 #endif /* USDT2 */
 JNI_END
 
@@ -991,8 +963,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, IsSameObject__entry, env, r1, r2);
 #else /* USDT2 */
-  HOTSPOT_JNI_ISSAMEOBJECT_ENTRY(
-                                 env, r1, r2);
+  HOTSPOT_JNI_ISSAMEOBJECT_ENTRY(env, r1, r2);
 #endif /* USDT2 */
   oop a = JNIHandles::resolve(r1);
   oop b = JNIHandles::resolve(r2);
@@ -1000,8 +971,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, IsSameObject__return, ret);
 #else /* USDT2 */
-  HOTSPOT_JNI_ISSAMEOBJECT_RETURN(
-                                  ret);
+  HOTSPOT_JNI_ISSAMEOBJECT_RETURN(ret);
 #endif /* USDT2 */
   return ret;
 JNI_END
@@ -1012,15 +982,13 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, NewLocalRef__entry, env, ref);
 #else /* USDT2 */
-  HOTSPOT_JNI_NEWLOCALREF_ENTRY(
-                                env, ref);
+  HOTSPOT_JNI_NEWLOCALREF_ENTRY(env, ref);
 #endif /* USDT2 */
   jobject ret = JNIHandles::make_local(env, JNIHandles::resolve(ref));
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, NewLocalRef__return, ret);
 #else /* USDT2 */
-  HOTSPOT_JNI_NEWLOCALREF_RETURN(
-                                 ret);
+  HOTSPOT_JNI_NEWLOCALREF_RETURN(ret);
 #endif /* USDT2 */
   return ret;
 JNI_END
@@ -1030,8 +998,7 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, EnsureLocalCapacity__entry, env, capacity);
 #else /* USDT2 */
-  HOTSPOT_JNI_ENSURELOCALCAPACITY_ENTRY(
-                                        env, capacity);
+  HOTSPOT_JNI_ENSURELOCALCAPACITY_ENTRY(env, capacity);
 #endif /* USDT2 */
   jint ret;
   if (capacity >= 0 &&
@@ -1043,8 +1010,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, EnsureLocalCapacity__return, ret);
 #else /* USDT2 */
-  HOTSPOT_JNI_ENSURELOCALCAPACITY_RETURN(
-                                         ret);
+  HOTSPOT_JNI_ENSURELOCALCAPACITY_RETURN(ret);
 #endif /* USDT2 */
   return ret;
 JNI_END
@@ -1055,8 +1021,7 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, GetObjectRefType__entry, env, obj);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETOBJECTREFTYPE_ENTRY(
-                                     env, obj);
+  HOTSPOT_JNI_GETOBJECTREFTYPE_ENTRY(env, obj);
 #endif /* USDT2 */
   jobjectRefType ret;
   if (JNIHandles::is_local_handle(thread, obj) ||
@@ -1071,8 +1036,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, GetObjectRefType__return, ret);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETOBJECTREFTYPE_RETURN(
-                                      (void *) ret);
+  HOTSPOT_JNI_GETOBJECTREFTYPE_RETURN((void *) ret);
 #endif /* USDT2 */
   return ret;
 JNI_END
@@ -1425,8 +1389,7 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, AllocObject__entry, env, clazz);
 #else /* USDT2 */
-  HOTSPOT_JNI_ALLOCOBJECT_ENTRY(
-                                env, clazz);
+  HOTSPOT_JNI_ALLOCOBJECT_ENTRY(env, clazz);
 #endif /* USDT2 */
   jobject ret = NULL;
   DT_RETURN_MARK(AllocObject, jobject, (const jobject&)ret);
@@ -1448,8 +1411,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, NewObjectA__entry, env, clazz, methodID);
 #else /* USDT2 */
-  HOTSPOT_JNI_NEWOBJECTA_ENTRY(
-                               env, clazz, (uintptr_t) methodID);
+  HOTSPOT_JNI_NEWOBJECTA_ENTRY(env, clazz, (uintptr_t) methodID);
 #endif /* USDT2 */
   jobject obj = NULL;
   DT_RETURN_MARK(NewObjectA, jobject, (const jobject&)obj);
@@ -1474,8 +1436,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, NewObjectV__entry, env, clazz, methodID);
 #else /* USDT2 */
-  HOTSPOT_JNI_NEWOBJECTV_ENTRY(
-                               env, clazz, (uintptr_t) methodID);
+  HOTSPOT_JNI_NEWOBJECTV_ENTRY(env, clazz, (uintptr_t) methodID);
 #endif /* USDT2 */
   jobject obj = NULL;
   DT_RETURN_MARK(NewObjectV, jobject, (const jobject&)obj);
@@ -1500,8 +1461,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, NewObject__entry, env, clazz, methodID);
 #else /* USDT2 */
-  HOTSPOT_JNI_NEWOBJECT_ENTRY(
-                              env, clazz, (uintptr_t) methodID);
+  HOTSPOT_JNI_NEWOBJECT_ENTRY(env, clazz, (uintptr_t) methodID);
 #endif /* USDT2 */
   jobject obj = NULL;
   DT_RETURN_MARK(NewObject, jobject, (const jobject&)obj);
@@ -1523,8 +1483,7 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, GetObjectClass__entry, env, obj);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETOBJECTCLASS_ENTRY(
-                                   env, obj);
+  HOTSPOT_JNI_GETOBJECTCLASS_ENTRY(env, obj);
 #endif /* USDT2 */
   Klass* k = JNIHandles::resolve_non_null(obj)->klass();
   jclass ret =
@@ -1532,8 +1491,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, GetObjectClass__return, ret);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETOBJECTCLASS_RETURN(
-                                    ret);
+  HOTSPOT_JNI_GETOBJECTCLASS_RETURN(ret);
 #endif /* USDT2 */
   return ret;
 JNI_END
@@ -1543,8 +1501,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, IsInstanceOf__entry, env, obj, clazz);
 #else /* USDT2 */
-  HOTSPOT_JNI_ISINSTANCEOF_ENTRY(
-                                 env, obj, clazz);
+  HOTSPOT_JNI_ISINSTANCEOF_ENTRY(env, obj, clazz);
 #endif /* USDT2 */
   jboolean ret = JNI_TRUE;
   if (obj != NULL) {
@@ -1558,8 +1515,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, IsInstanceOf__return, ret);
 #else /* USDT2 */
-  HOTSPOT_JNI_ISINSTANCEOF_RETURN(
-                                  ret);
+  HOTSPOT_JNI_ISINSTANCEOF_RETURN(ret);
 #endif /* USDT2 */
   return ret;
 JNI_END
@@ -1623,15 +1579,13 @@
 #ifndef USDT2
   DTRACE_PROBE4(hotspot_jni, GetMethodID__entry, env, clazz, name, sig);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETMETHODID_ENTRY(
-                                env, clazz, (char *) name, (char *) sig);
+  HOTSPOT_JNI_GETMETHODID_ENTRY(env, clazz, (char *) name, (char *) sig);
 #endif /* USDT2 */
   jmethodID ret = get_method_id(env, clazz, name, sig, false, thread);
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, GetMethodID__return, ret);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETMETHODID_RETURN(
-                                 (uintptr_t) ret);
+  HOTSPOT_JNI_GETMETHODID_RETURN((uintptr_t) ret);
 #endif /* USDT2 */
   return ret;
 JNI_END
@@ -1643,15 +1597,13 @@
 #ifndef USDT2
   DTRACE_PROBE4(hotspot_jni, GetStaticMethodID__entry, env, clazz, name, sig);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETSTATICMETHODID_ENTRY(
-                                      env, (char *) clazz, (char *) name, (char *)sig);
+  HOTSPOT_JNI_GETSTATICMETHODID_ENTRY(env, (char *) clazz, (char *) name, (char *)sig);
 #endif /* USDT2 */
   jmethodID ret = get_method_id(env, clazz, name, sig, true, thread);
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, GetStaticMethodID__return, ret);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETSTATICMETHODID_RETURN(
-                                       (uintptr_t) ret);
+  HOTSPOT_JNI_GETSTATICMETHODID_RETURN((uintptr_t) ret);
 #endif /* USDT2 */
   return ret;
 JNI_END
@@ -1911,8 +1863,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, CallVoidMethod__entry, env, obj, methodID);
 #else /* USDT2 */
-  HOTSPOT_JNI_CALLVOIDMETHOD_ENTRY(
-                                   env, obj, (uintptr_t) methodID);
+  HOTSPOT_JNI_CALLVOIDMETHOD_ENTRY(env, obj, (uintptr_t) methodID);
 #endif /* USDT2 */
   DT_VOID_RETURN_MARK(CallVoidMethod);
 
@@ -1930,8 +1881,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, CallVoidMethodV__entry, env, obj, methodID);
 #else /* USDT2 */
-  HOTSPOT_JNI_CALLVOIDMETHODV_ENTRY(
-                                    env, obj, (uintptr_t) methodID);
+  HOTSPOT_JNI_CALLVOIDMETHODV_ENTRY(env, obj, (uintptr_t) methodID);
 #endif /* USDT2 */
   DT_VOID_RETURN_MARK(CallVoidMethodV);
 
@@ -1946,8 +1896,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, CallVoidMethodA__entry, env, obj, methodID);
 #else /* USDT2 */
-  HOTSPOT_JNI_CALLVOIDMETHODA_ENTRY(
-                                    env, obj, (uintptr_t) methodID);
+  HOTSPOT_JNI_CALLVOIDMETHODA_ENTRY(env, obj, (uintptr_t) methodID);
 #endif /* USDT2 */
   DT_VOID_RETURN_MARK(CallVoidMethodA);
 
@@ -2209,8 +2158,7 @@
   DTRACE_PROBE4(hotspot_jni, CallNonvirtualVoidMethod__entry,
                env, obj, cls, methodID);
 #else /* USDT2 */
-  HOTSPOT_JNI_CALLNONVIRTUALVOIDMETHOD_ENTRY(
-               env, obj, cls, (uintptr_t) methodID);
+  HOTSPOT_JNI_CALLNONVIRTUALVOIDMETHOD_ENTRY(env, obj, cls, (uintptr_t) methodID);
 #endif /* USDT2 */
   DT_VOID_RETURN_MARK(CallNonvirtualVoidMethod);
 
@@ -2511,8 +2459,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, CallStaticVoidMethod__entry, env, cls, methodID);
 #else /* USDT2 */
-  HOTSPOT_JNI_CALLSTATICVOIDMETHOD_ENTRY(
-                                         env, cls, (uintptr_t) methodID);
+  HOTSPOT_JNI_CALLSTATICVOIDMETHOD_ENTRY(env, cls, (uintptr_t) methodID);
 #endif /* USDT2 */
   DT_VOID_RETURN_MARK(CallStaticVoidMethod);
 
@@ -2530,8 +2477,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, CallStaticVoidMethodV__entry, env, cls, methodID);
 #else /* USDT2 */
-  HOTSPOT_JNI_CALLSTATICVOIDMETHODV_ENTRY(
-                                          env, cls, (uintptr_t) methodID);
+  HOTSPOT_JNI_CALLSTATICVOIDMETHODV_ENTRY(env, cls, (uintptr_t) methodID);
 #endif /* USDT2 */
   DT_VOID_RETURN_MARK(CallStaticVoidMethodV);
 
@@ -2546,8 +2492,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, CallStaticVoidMethodA__entry, env, cls, methodID);
 #else /* USDT2 */
-  HOTSPOT_JNI_CALLSTATICVOIDMETHODA_ENTRY(
-                                          env, cls, (uintptr_t) methodID);
+  HOTSPOT_JNI_CALLSTATICVOIDMETHODA_ENTRY(env, cls, (uintptr_t) methodID);
 #endif /* USDT2 */
   DT_VOID_RETURN_MARK(CallStaticVoidMethodA);
 
@@ -2575,8 +2520,7 @@
 #ifndef USDT2
   DTRACE_PROBE4(hotspot_jni, GetFieldID__entry, env, clazz, name, sig);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETFIELDID_ENTRY(
-                               env, clazz, (char *) name, (char *) sig);
+  HOTSPOT_JNI_GETFIELDID_ENTRY(env, clazz, (char *) name, (char *) sig);
 #endif /* USDT2 */
   jfieldID ret = 0;
   DT_RETURN_MARK(GetFieldID, jfieldID, (const jfieldID&)ret);
@@ -2612,8 +2556,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, GetObjectField__entry, env, obj, fieldID);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETOBJECTFIELD_ENTRY(
-                                   env, obj, (uintptr_t) fieldID);
+  HOTSPOT_JNI_GETOBJECTFIELD_ENTRY(env, obj, (uintptr_t) fieldID);
 #endif /* USDT2 */
   oop o = JNIHandles::resolve_non_null(obj);
   Klass* k = o->klass();
@@ -2647,8 +2590,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, GetObjectField__return, ret);
 #else /* USDT2 */
-HOTSPOT_JNI_GETOBJECTFIELD_RETURN(
-                                  ret);
+HOTSPOT_JNI_GETOBJECTFIELD_RETURN(ret);
 #endif /* USDT2 */
   return ret;
 JNI_END
@@ -2773,8 +2715,7 @@
 #ifndef USDT2
   DTRACE_PROBE4(hotspot_jni, SetObjectField__entry, env, obj, fieldID, value);
 #else /* USDT2 */
-  HOTSPOT_JNI_SETOBJECTFIELD_ENTRY(
-                                   env, obj, (uintptr_t) fieldID, value);
+  HOTSPOT_JNI_SETOBJECTFIELD_ENTRY(env, obj, (uintptr_t) fieldID, value);
 #endif /* USDT2 */
   oop o = JNIHandles::resolve_non_null(obj);
   Klass* k = o->klass();
@@ -2791,8 +2732,7 @@
 #ifndef USDT2
   DTRACE_PROBE(hotspot_jni, SetObjectField__return);
 #else /* USDT2 */
-  HOTSPOT_JNI_SETOBJECTFIELD_RETURN(
-);
+  HOTSPOT_JNI_SETOBJECTFIELD_RETURN();
 #endif /* USDT2 */
 JNI_END
 
@@ -2896,8 +2836,7 @@
   DTRACE_PROBE4(hotspot_jni, ToReflectedField__entry,
                 env, cls, fieldID, isStatic);
 #else /* USDT2 */
-  HOTSPOT_JNI_TOREFLECTEDFIELD_ENTRY(
-                env, cls, (uintptr_t) fieldID, isStatic);
+  HOTSPOT_JNI_TOREFLECTEDFIELD_ENTRY(env, cls, (uintptr_t) fieldID, isStatic);
 #endif /* USDT2 */
   jobject ret = NULL;
   DT_RETURN_MARK(ToReflectedField, jobject, (const jobject&)ret);
@@ -2941,8 +2880,7 @@
 #ifndef USDT2
   DTRACE_PROBE4(hotspot_jni, GetStaticFieldID__entry, env, clazz, name, sig);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETSTATICFIELDID_ENTRY(
-                                     env, clazz, (char *) name, (char *) sig);
+  HOTSPOT_JNI_GETSTATICFIELDID_ENTRY(env, clazz, (char *) name, (char *) sig);
 #endif /* USDT2 */
   jfieldID ret = NULL;
   DT_RETURN_MARK(GetStaticFieldID, jfieldID, (const jfieldID&)ret);
@@ -2982,8 +2920,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, GetStaticObjectField__entry, env, clazz, fieldID);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETSTATICOBJECTFIELD_ENTRY(
-                                         env, clazz, (uintptr_t) fieldID);
+  HOTSPOT_JNI_GETSTATICOBJECTFIELD_ENTRY(env, clazz, (uintptr_t) fieldID);
 #endif /* USDT2 */
 #if INCLUDE_JNI_CHECK
   DEBUG_ONLY(Klass* param_k = jniCheck::validate_class(thread, clazz);)
@@ -2999,8 +2936,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, GetStaticObjectField__return, ret);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETSTATICOBJECTFIELD_RETURN(
-                                          ret);
+  HOTSPOT_JNI_GETSTATICOBJECTFIELD_RETURN(ret);
 #endif /* USDT2 */
   return ret;
 JNI_END
@@ -3085,8 +3021,7 @@
 #ifndef USDT2
   DTRACE_PROBE4(hotspot_jni, SetStaticObjectField__entry, env, clazz, fieldID, value);
 #else /* USDT2 */
- HOTSPOT_JNI_SETSTATICOBJECTFIELD_ENTRY(
-                                        env, clazz, (uintptr_t) fieldID, value);
+ HOTSPOT_JNI_SETSTATICOBJECTFIELD_ENTRY(env, clazz, (uintptr_t) fieldID, value);
 #endif /* USDT2 */
   JNIid* id = jfieldIDWorkaround::from_static_jfieldID(fieldID);
   assert(id->is_static_field_id(), "invalid static field id");
@@ -3101,8 +3036,7 @@
 #ifndef USDT2
   DTRACE_PROBE(hotspot_jni, SetStaticObjectField__return);
 #else /* USDT2 */
-  HOTSPOT_JNI_SETSTATICOBJECTFIELD_RETURN(
-                                          );
+  HOTSPOT_JNI_SETSTATICOBJECTFIELD_RETURN();
 #endif /* USDT2 */
 JNI_END
 
@@ -3206,8 +3140,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, NewString__entry, env, unicodeChars, len);
 #else /* USDT2 */
- HOTSPOT_JNI_NEWSTRING_ENTRY(
-                             env, (uint16_t *) unicodeChars, len);
+ HOTSPOT_JNI_NEWSTRING_ENTRY(env, (uint16_t *) unicodeChars, len);
 #endif /* USDT2 */
   jstring ret = NULL;
   DT_RETURN_MARK(NewString, jstring, (const jstring&)ret);
@@ -3222,8 +3155,7 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, GetStringLength__entry, env, string);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETSTRINGLENGTH_ENTRY(
-                                    env, string);
+  HOTSPOT_JNI_GETSTRINGLENGTH_ENTRY(env, string);
 #endif /* USDT2 */
   jsize ret = 0;
   oop s = JNIHandles::resolve_non_null(string);
@@ -3233,8 +3165,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, GetStringLength__return, ret);
 #else /* USDT2 */
- HOTSPOT_JNI_GETSTRINGLENGTH_RETURN(
-                                    ret);
+ HOTSPOT_JNI_GETSTRINGLENGTH_RETURN(ret);
 #endif /* USDT2 */
   return ret;
 JNI_END
@@ -3246,8 +3177,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, GetStringChars__entry, env, string, isCopy);
 #else /* USDT2 */
- HOTSPOT_JNI_GETSTRINGCHARS_ENTRY(
-                                  env, string, (uintptr_t *) isCopy);
+ HOTSPOT_JNI_GETSTRINGCHARS_ENTRY(env, string, (uintptr_t *) isCopy);
 #endif /* USDT2 */
   jchar* buf = NULL;
   oop s = JNIHandles::resolve_non_null(string);
@@ -3271,8 +3201,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, GetStringChars__return, buf);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETSTRINGCHARS_RETURN(
-                                    buf);
+  HOTSPOT_JNI_GETSTRINGCHARS_RETURN(buf);
 #endif /* USDT2 */
   return buf;
 JNI_END
@@ -3283,8 +3212,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, ReleaseStringChars__entry, env, str, chars);
 #else /* USDT2 */
-  HOTSPOT_JNI_RELEASESTRINGCHARS_ENTRY(
-                                       env, str, (uint16_t *) chars);
+  HOTSPOT_JNI_RELEASESTRINGCHARS_ENTRY(env, str, (uint16_t *) chars);
 #endif /* USDT2 */
   //%note jni_6
   if (chars != NULL) {
@@ -3295,8 +3223,7 @@
 #ifndef USDT2
   DTRACE_PROBE(hotspot_jni, ReleaseStringChars__return);
 #else /* USDT2 */
-  HOTSPOT_JNI_RELEASESTRINGCHARS_RETURN(
-);
+  HOTSPOT_JNI_RELEASESTRINGCHARS_RETURN();
 #endif /* USDT2 */
 JNI_END
 
@@ -3315,8 +3242,7 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, NewStringUTF__entry, env, bytes);
 #else /* USDT2 */
-  HOTSPOT_JNI_NEWSTRINGUTF_ENTRY(
-                                 env, (char *) bytes);
+  HOTSPOT_JNI_NEWSTRINGUTF_ENTRY(env, (char *) bytes);
 #endif /* USDT2 */
   jstring ret;
   DT_RETURN_MARK(NewStringUTF, jstring, (const jstring&)ret);
@@ -3332,8 +3258,7 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, GetStringUTFLength__entry, env, string);
 #else /* USDT2 */
- HOTSPOT_JNI_GETSTRINGUTFLENGTH_ENTRY(
-                                      env, string);
+ HOTSPOT_JNI_GETSTRINGUTFLENGTH_ENTRY(env, string);
 #endif /* USDT2 */
   jsize ret = 0;
   oop java_string = JNIHandles::resolve_non_null(string);
@@ -3343,8 +3268,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, GetStringUTFLength__return, ret);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETSTRINGUTFLENGTH_RETURN(
-                                        ret);
+  HOTSPOT_JNI_GETSTRINGUTFLENGTH_RETURN(ret);
 #endif /* USDT2 */
   return ret;
 JNI_END
@@ -3355,8 +3279,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, GetStringUTFChars__entry, env, string, isCopy);
 #else /* USDT2 */
- HOTSPOT_JNI_GETSTRINGUTFCHARS_ENTRY(
-                                     env, string, (uintptr_t *) isCopy);
+ HOTSPOT_JNI_GETSTRINGUTFCHARS_ENTRY(env, string, (uintptr_t *) isCopy);
 #endif /* USDT2 */
   char* result = NULL;
   oop java_string = JNIHandles::resolve_non_null(string);
@@ -3374,8 +3297,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, GetStringUTFChars__return, result);
 #else /* USDT2 */
- HOTSPOT_JNI_GETSTRINGUTFCHARS_RETURN(
-                                      result);
+ HOTSPOT_JNI_GETSTRINGUTFCHARS_RETURN(result);
 #endif /* USDT2 */
   return result;
 JNI_END
@@ -3386,8 +3308,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, ReleaseStringUTFChars__entry, env, str, chars);
 #else /* USDT2 */
- HOTSPOT_JNI_RELEASESTRINGUTFCHARS_ENTRY(
-                                         env, str, (char *) chars);
+ HOTSPOT_JNI_RELEASESTRINGUTFCHARS_ENTRY(env, str, (char *) chars);
 #endif /* USDT2 */
   if (chars != NULL) {
     FreeHeap((char*) chars);
@@ -3395,8 +3316,7 @@
 #ifndef USDT2
   DTRACE_PROBE(hotspot_jni, ReleaseStringUTFChars__return);
 #else /* USDT2 */
-HOTSPOT_JNI_RELEASESTRINGUTFCHARS_RETURN(
-);
+HOTSPOT_JNI_RELEASESTRINGUTFCHARS_RETURN();
 #endif /* USDT2 */
 JNI_END
 
@@ -3406,8 +3326,7 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, GetArrayLength__entry, env, array);
 #else /* USDT2 */
- HOTSPOT_JNI_GETARRAYLENGTH_ENTRY(
-                                  env, array);
+ HOTSPOT_JNI_GETARRAYLENGTH_ENTRY(env, array);
 #endif /* USDT2 */
   arrayOop a = arrayOop(JNIHandles::resolve_non_null(array));
   assert(a->is_array(), "must be array");
@@ -3415,8 +3334,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, GetArrayLength__return, ret);
 #else /* USDT2 */
- HOTSPOT_JNI_GETARRAYLENGTH_RETURN(
-                                   ret);
+ HOTSPOT_JNI_GETARRAYLENGTH_RETURN(ret);
 #endif /* USDT2 */
   return ret;
 JNI_END
@@ -3438,8 +3356,7 @@
 #ifndef USDT2
   DTRACE_PROBE4(hotspot_jni, NewObjectArray__entry, env, length, elementClass, initialElement);
 #else /* USDT2 */
- HOTSPOT_JNI_NEWOBJECTARRAY_ENTRY(
-                                  env, length, elementClass, initialElement);
+ HOTSPOT_JNI_NEWOBJECTARRAY_ENTRY(env, length, elementClass, initialElement);
 #endif /* USDT2 */
   jobjectArray ret = NULL;
   DT_RETURN_MARK(NewObjectArray, jobjectArray, (const jobjectArray&)ret);
@@ -3470,8 +3387,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, GetObjectArrayElement__entry, env, array, index);
 #else /* USDT2 */
- HOTSPOT_JNI_GETOBJECTARRAYELEMENT_ENTRY(
-                                         env, array, index);
+ HOTSPOT_JNI_GETOBJECTARRAYELEMENT_ENTRY(env, array, index);
 #endif /* USDT2 */
   jobject ret = NULL;
   DT_RETURN_MARK(GetObjectArrayElement, jobject, (const jobject&)ret);
@@ -3498,8 +3414,7 @@
 #ifndef USDT2
   DTRACE_PROBE4(hotspot_jni, SetObjectArrayElement__entry, env, array, index, value);
 #else /* USDT2 */
- HOTSPOT_JNI_SETOBJECTARRAYELEMENT_ENTRY(
-                                         env, array, index, value);
+ HOTSPOT_JNI_SETOBJECTARRAYELEMENT_ENTRY(env, array, index, value);
 #endif /* USDT2 */
   DT_VOID_RETURN_MARK(SetObjectArrayElement);
 
@@ -4052,8 +3967,7 @@
 #ifndef USDT2
   DTRACE_PROBE4(hotspot_jni, RegisterNatives__entry, env, clazz, methods, nMethods);
 #else /* USDT2 */
-  HOTSPOT_JNI_REGISTERNATIVES_ENTRY(
-                                    env, clazz, (void *) methods, nMethods);
+  HOTSPOT_JNI_REGISTERNATIVES_ENTRY(env, clazz, (void *) methods, nMethods);
 #endif /* USDT2 */
   jint ret = 0;
   DT_RETURN_MARK(RegisterNatives, jint, (const jint&)ret);
@@ -4095,8 +4009,7 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, UnregisterNatives__entry, env, clazz);
 #else /* USDT2 */
- HOTSPOT_JNI_UNREGISTERNATIVES_ENTRY(
-                                     env, clazz);
+ HOTSPOT_JNI_UNREGISTERNATIVES_ENTRY(env, clazz);
 #endif /* USDT2 */
   Klass* k   = java_lang_Class::as_Klass(JNIHandles::resolve_non_null(clazz));
   //%note jni_2
@@ -4112,8 +4025,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, UnregisterNatives__return, 0);
 #else /* USDT2 */
- HOTSPOT_JNI_UNREGISTERNATIVES_RETURN(
-                                      0);
+ HOTSPOT_JNI_UNREGISTERNATIVES_RETURN(0);
 #endif /* USDT2 */
   return 0;
 JNI_END
@@ -4133,8 +4045,7 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, MonitorEnter__entry, env, jobj);
 #else /* USDT2 */
- HOTSPOT_JNI_MONITORENTER_ENTRY(
-                                env, jobj);
+ HOTSPOT_JNI_MONITORENTER_ENTRY(env, jobj);
 #endif /* USDT2 */
   jint ret = JNI_ERR;
   DT_RETURN_MARK(MonitorEnter, jint, (const jint&)ret);
@@ -4161,8 +4072,7 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, MonitorExit__entry, env, jobj);
 #else /* USDT2 */
- HOTSPOT_JNI_MONITOREXIT_ENTRY(
-                               env, jobj);
+ HOTSPOT_JNI_MONITOREXIT_ENTRY(env, jobj);
 #endif /* USDT2 */
   jint ret = JNI_ERR;
   DT_RETURN_MARK(MonitorExit, jint, (const jint&)ret);
@@ -4195,8 +4105,7 @@
 #ifndef USDT2
   DTRACE_PROBE5(hotspot_jni, GetStringRegion__entry, env, string, start, len, buf);
 #else /* USDT2 */
- HOTSPOT_JNI_GETSTRINGREGION_ENTRY(
-                                   env, string, start, len, buf);
+ HOTSPOT_JNI_GETSTRINGREGION_ENTRY(env, string, start, len, buf);
 #endif /* USDT2 */
   DT_VOID_RETURN_MARK(GetStringRegion);
   oop s = JNIHandles::resolve_non_null(string);
@@ -4224,8 +4133,7 @@
 #ifndef USDT2
   DTRACE_PROBE5(hotspot_jni, GetStringUTFRegion__entry, env, string, start, len, buf);
 #else /* USDT2 */
- HOTSPOT_JNI_GETSTRINGUTFREGION_ENTRY(
-                                      env, string, start, len, buf);
+ HOTSPOT_JNI_GETSTRINGUTFREGION_ENTRY(env, string, start, len, buf);
 #endif /* USDT2 */
   DT_VOID_RETURN_MARK(GetStringUTFRegion);
   oop s = JNIHandles::resolve_non_null(string);
@@ -4255,8 +4163,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, GetPrimitiveArrayCritical__entry, env, array, isCopy);
 #else /* USDT2 */
- HOTSPOT_JNI_GETPRIMITIVEARRAYCRITICAL_ENTRY(
-                                             env, array, (uintptr_t *) isCopy);
+ HOTSPOT_JNI_GETPRIMITIVEARRAYCRITICAL_ENTRY(env, array, (uintptr_t *) isCopy);
 #endif /* USDT2 */
   GC_locker::lock_critical(thread);
   if (isCopy != NULL) {
@@ -4274,8 +4181,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, GetPrimitiveArrayCritical__return, ret);
 #else /* USDT2 */
- HOTSPOT_JNI_GETPRIMITIVEARRAYCRITICAL_RETURN(
-                                              ret);
+ HOTSPOT_JNI_GETPRIMITIVEARRAYCRITICAL_RETURN(ret);
 #endif /* USDT2 */
   return ret;
 JNI_END
@@ -4286,16 +4192,14 @@
 #ifndef USDT2
   DTRACE_PROBE4(hotspot_jni, ReleasePrimitiveArrayCritical__entry, env, array, carray, mode);
 #else /* USDT2 */
-  HOTSPOT_JNI_RELEASEPRIMITIVEARRAYCRITICAL_ENTRY(
-                                                  env, array, carray, mode);
+  HOTSPOT_JNI_RELEASEPRIMITIVEARRAYCRITICAL_ENTRY(env, array, carray, mode);
 #endif /* USDT2 */
   // The array, carray and mode arguments are ignored
   GC_locker::unlock_critical(thread);
 #ifndef USDT2
   DTRACE_PROBE(hotspot_jni, ReleasePrimitiveArrayCritical__return);
 #else /* USDT2 */
-HOTSPOT_JNI_RELEASEPRIMITIVEARRAYCRITICAL_RETURN(
-);
+HOTSPOT_JNI_RELEASEPRIMITIVEARRAYCRITICAL_RETURN();
 #endif /* USDT2 */
 JNI_END
 
@@ -4305,8 +4209,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, GetStringCritical__entry, env, string, isCopy);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETSTRINGCRITICAL_ENTRY(
-                                      env, string, (uintptr_t *) isCopy);
+  HOTSPOT_JNI_GETSTRINGCRITICAL_ENTRY(env, string, (uintptr_t *) isCopy);
 #endif /* USDT2 */
   GC_locker::lock_critical(thread);
   if (isCopy != NULL) {
@@ -4325,8 +4228,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, GetStringCritical__return, ret);
 #else /* USDT2 */
- HOTSPOT_JNI_GETSTRINGCRITICAL_RETURN(
-                                      (uint16_t *) ret);
+ HOTSPOT_JNI_GETSTRINGCRITICAL_RETURN((uint16_t *) ret);
 #endif /* USDT2 */
   return ret;
 JNI_END
@@ -4337,16 +4239,14 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, ReleaseStringCritical__entry, env, str, chars);
 #else /* USDT2 */
-  HOTSPOT_JNI_RELEASESTRINGCRITICAL_ENTRY(
-                                          env, str, (uint16_t *) chars);
+  HOTSPOT_JNI_RELEASESTRINGCRITICAL_ENTRY(env, str, (uint16_t *) chars);
 #endif /* USDT2 */
   // The str and chars arguments are ignored
   GC_locker::unlock_critical(thread);
 #ifndef USDT2
   DTRACE_PROBE(hotspot_jni, ReleaseStringCritical__return);
 #else /* USDT2 */
-HOTSPOT_JNI_RELEASESTRINGCRITICAL_RETURN(
-);
+HOTSPOT_JNI_RELEASESTRINGCRITICAL_RETURN();
 #endif /* USDT2 */
 JNI_END
 
@@ -4356,16 +4256,14 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, NewWeakGlobalRef__entry, env, ref);
 #else /* USDT2 */
- HOTSPOT_JNI_NEWWEAKGLOBALREF_ENTRY(
-                                    env, ref);
+ HOTSPOT_JNI_NEWWEAKGLOBALREF_ENTRY(env, ref);
 #endif /* USDT2 */
   Handle ref_handle(thread, JNIHandles::resolve(ref));
   jweak ret = JNIHandles::make_weak_global(ref_handle);
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, NewWeakGlobalRef__return, ret);
 #else /* USDT2 */
- HOTSPOT_JNI_NEWWEAKGLOBALREF_RETURN(
-                                     ret);
+ HOTSPOT_JNI_NEWWEAKGLOBALREF_RETURN(ret);
 #endif /* USDT2 */
   return ret;
 JNI_END
@@ -4376,15 +4274,13 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, DeleteWeakGlobalRef__entry, env, ref);
 #else /* USDT2 */
-  HOTSPOT_JNI_DELETEWEAKGLOBALREF_ENTRY(
-                                        env, ref);
+  HOTSPOT_JNI_DELETEWEAKGLOBALREF_ENTRY(env, ref);
 #endif /* USDT2 */
   JNIHandles::destroy_weak_global(ref);
 #ifndef USDT2
   DTRACE_PROBE(hotspot_jni, DeleteWeakGlobalRef__return);
 #else /* USDT2 */
-  HOTSPOT_JNI_DELETEWEAKGLOBALREF_RETURN(
-                                         );
+  HOTSPOT_JNI_DELETEWEAKGLOBALREF_RETURN();
 #endif /* USDT2 */
 JNI_END
 
@@ -4394,16 +4290,14 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, ExceptionCheck__entry, env);
 #else /* USDT2 */
- HOTSPOT_JNI_EXCEPTIONCHECK_ENTRY(
-                                  env);
+ HOTSPOT_JNI_EXCEPTIONCHECK_ENTRY(env);
 #endif /* USDT2 */
   jni_check_async_exceptions(thread);
   jboolean ret = (thread->has_pending_exception()) ? JNI_TRUE : JNI_FALSE;
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, ExceptionCheck__return, ret);
 #else /* USDT2 */
- HOTSPOT_JNI_EXCEPTIONCHECK_RETURN(
-                                   ret);
+ HOTSPOT_JNI_EXCEPTIONCHECK_RETURN(ret);
 #endif /* USDT2 */
   return ret;
 JNI_END
@@ -4514,8 +4408,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, NewDirectByteBuffer__entry, env, address, capacity);
 #else /* USDT2 */
- HOTSPOT_JNI_NEWDIRECTBYTEBUFFER_ENTRY(
-                                       env, address, capacity);
+ HOTSPOT_JNI_NEWDIRECTBYTEBUFFER_ENTRY(env, address, capacity);
 #endif /* USDT2 */
 
   if (!directBufferSupportInitializeEnded) {
@@ -4523,8 +4416,7 @@
 #ifndef USDT2
       DTRACE_PROBE1(hotspot_jni, NewDirectByteBuffer__return, NULL);
 #else /* USDT2 */
-      HOTSPOT_JNI_NEWDIRECTBYTEBUFFER_RETURN(
-                                             NULL);
+      HOTSPOT_JNI_NEWDIRECTBYTEBUFFER_RETURN(NULL);
 #endif /* USDT2 */
       return NULL;
     }
@@ -4539,8 +4431,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, NewDirectByteBuffer__return, ret);
 #else /* USDT2 */
-  HOTSPOT_JNI_NEWDIRECTBYTEBUFFER_RETURN(
-                                         ret);
+  HOTSPOT_JNI_NEWDIRECTBYTEBUFFER_RETURN(ret);
 #endif /* USDT2 */
   return ret;
 }
@@ -4561,8 +4452,7 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, GetDirectBufferAddress__entry, env, buf);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETDIRECTBUFFERADDRESS_ENTRY(
-                                           env, buf);
+  HOTSPOT_JNI_GETDIRECTBUFFERADDRESS_ENTRY(env, buf);
 #endif /* USDT2 */
   void* ret = NULL;
   DT_RETURN_MARK(GetDirectBufferAddress, void*, (const void*&)ret);
@@ -4597,8 +4487,7 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, GetDirectBufferCapacity__entry, env, buf);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETDIRECTBUFFERCAPACITY_ENTRY(
-                                            env, buf);
+  HOTSPOT_JNI_GETDIRECTBUFFERCAPACITY_ENTRY(env, buf);
 #endif /* USDT2 */
   jlong ret = -1;
   DT_RETURN_MARK(GetDirectBufferCapacity, jlong, (const jlong&)ret);
@@ -4629,14 +4518,12 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, GetVersion__entry, env);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETVERSION_ENTRY(
-                               env);
+  HOTSPOT_JNI_GETVERSION_ENTRY(env);
 #endif /* USDT2 */
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, GetVersion__return, CurrentVersion);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETVERSION_RETURN(
-                                CurrentVersion);
+  HOTSPOT_JNI_GETVERSION_RETURN(CurrentVersion);
 #endif /* USDT2 */
   return CurrentVersion;
 JNI_END
@@ -4648,15 +4535,13 @@
 #ifndef USDT2
   DTRACE_PROBE2(hotspot_jni, GetJavaVM__entry, env, vm);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETJAVAVM_ENTRY(
-                              env, (void **) vm);
+  HOTSPOT_JNI_GETJAVAVM_ENTRY(env, (void **) vm);
 #endif /* USDT2 */
   *vm  = (JavaVM *)(&main_vm);
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, GetJavaVM__return, JNI_OK);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETJAVAVM_RETURN(
-                               JNI_OK);
+  HOTSPOT_JNI_GETJAVAVM_RETURN(JNI_OK);
 #endif /* USDT2 */
   return JNI_OK;
 JNI_END
@@ -5065,8 +4950,7 @@
 #ifndef USDT2
   HS_DTRACE_PROBE1(hotspot_jni, GetDefaultJavaVMInitArgs__entry, args_);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETDEFAULTJAVAVMINITARGS_ENTRY(
-                                             args_);
+  HOTSPOT_JNI_GETDEFAULTJAVAVMINITARGS_ENTRY(args_);
 #endif /* USDT2 */
   JDK1_1InitArgs *args = (JDK1_1InitArgs *)args_;
   jint ret = JNI_ERR;
@@ -5190,8 +5074,7 @@
 #ifndef USDT2
   HS_DTRACE_PROBE3(hotspot_jni, CreateJavaVM__entry, vm, penv, args);
 #else /* USDT2 */
-  HOTSPOT_JNI_CREATEJAVAVM_ENTRY(
-                                 (void **) vm, penv, args);
+  HOTSPOT_JNI_CREATEJAVAVM_ENTRY((void **) vm, penv, args);
 #endif /* USDT2 */
 
   jint result = JNI_ERR;
@@ -5309,8 +5192,7 @@
   HS_DTRACE_PROBE3(hotspot_jni, GetCreatedJavaVMs__entry, \
     vm_buf, bufLen, numVMs);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETCREATEDJAVAVMS_ENTRY(
-                                      (void **) vm_buf, bufLen, (uintptr_t *) numVMs);
+  HOTSPOT_JNI_GETCREATEDJAVAVMS_ENTRY((void **) vm_buf, bufLen, (uintptr_t *) numVMs);
 #endif /* USDT2 */
   if (vm_created) {
     if (numVMs != NULL) *numVMs = 1;
@@ -5321,8 +5203,7 @@
 #ifndef USDT2
   HS_DTRACE_PROBE1(hotspot_jni, GetCreatedJavaVMs__return, JNI_OK);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETCREATEDJAVAVMS_RETURN(
-                                    JNI_OK);
+  HOTSPOT_JNI_GETCREATEDJAVAVMS_RETURN(JNI_OK);
 #endif /* USDT2 */
   return JNI_OK;
 }
@@ -5340,8 +5221,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, DestroyJavaVM__entry, vm);
 #else /* USDT2 */
-  HOTSPOT_JNI_DESTROYJAVAVM_ENTRY(
-                                  vm);
+  HOTSPOT_JNI_DESTROYJAVAVM_ENTRY(vm);
 #endif /* USDT2 */
   jint res = JNI_ERR;
   DT_RETURN_MARK(DestroyJavaVM, jint, (const jint&)res);
@@ -5493,15 +5373,13 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, AttachCurrentThread__entry, vm, penv, _args);
 #else /* USDT2 */
-  HOTSPOT_JNI_ATTACHCURRENTTHREAD_ENTRY(
-                                        vm, penv, _args);
+  HOTSPOT_JNI_ATTACHCURRENTTHREAD_ENTRY(vm, penv, _args);
 #endif /* USDT2 */
   if (!vm_created) {
 #ifndef USDT2
     DTRACE_PROBE1(hotspot_jni, AttachCurrentThread__return, JNI_ERR);
 #else /* USDT2 */
-  HOTSPOT_JNI_ATTACHCURRENTTHREAD_RETURN(
-                                         (uint32_t) JNI_ERR);
+  HOTSPOT_JNI_ATTACHCURRENTTHREAD_RETURN((uint32_t) JNI_ERR);
 #endif /* USDT2 */
     return JNI_ERR;
   }
@@ -5511,8 +5389,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, AttachCurrentThread__return, ret);
 #else /* USDT2 */
-  HOTSPOT_JNI_ATTACHCURRENTTHREAD_RETURN(
-                                         ret);
+  HOTSPOT_JNI_ATTACHCURRENTTHREAD_RETURN(ret);
 #endif /* USDT2 */
   return ret;
 }
@@ -5522,8 +5399,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, DetachCurrentThread__entry, vm);
 #else /* USDT2 */
-  HOTSPOT_JNI_DETACHCURRENTTHREAD_ENTRY(
-                                        vm);
+  HOTSPOT_JNI_DETACHCURRENTTHREAD_ENTRY(vm);
 #endif /* USDT2 */
   VM_Exit::block_if_vm_exited();
 
@@ -5534,8 +5410,7 @@
 #ifndef USDT2
     DTRACE_PROBE1(hotspot_jni, DetachCurrentThread__return, JNI_OK);
 #else /* USDT2 */
-  HOTSPOT_JNI_DETACHCURRENTTHREAD_RETURN(
-                                         JNI_OK);
+  HOTSPOT_JNI_DETACHCURRENTTHREAD_RETURN(JNI_OK);
 #endif /* USDT2 */
     return JNI_OK;
   }
@@ -5545,8 +5420,7 @@
 #ifndef USDT2
     DTRACE_PROBE1(hotspot_jni, DetachCurrentThread__return, JNI_ERR);
 #else /* USDT2 */
-  HOTSPOT_JNI_DETACHCURRENTTHREAD_RETURN(
-                                         (uint32_t) JNI_ERR);
+  HOTSPOT_JNI_DETACHCURRENTTHREAD_RETURN((uint32_t) JNI_ERR);
 #endif /* USDT2 */
     // Can't detach a thread that's running java, that can't work.
     return JNI_ERR;
@@ -5571,8 +5445,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, DetachCurrentThread__return, JNI_OK);
 #else /* USDT2 */
-  HOTSPOT_JNI_DETACHCURRENTTHREAD_RETURN(
-                                         JNI_OK);
+  HOTSPOT_JNI_DETACHCURRENTTHREAD_RETURN(JNI_OK);
 #endif /* USDT2 */
   return JNI_OK;
 }
@@ -5588,8 +5461,7 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, GetEnv__entry, vm, penv, version);
 #else /* USDT2 */
-  HOTSPOT_JNI_GETENV_ENTRY(
-                           vm, penv, version);
+  HOTSPOT_JNI_GETENV_ENTRY(vm, penv, version);
 #endif /* USDT2 */
   jint ret = JNI_ERR;
   DT_RETURN_MARK(GetEnv, jint, (const jint&)ret);
@@ -5647,15 +5519,13 @@
 #ifndef USDT2
   DTRACE_PROBE3(hotspot_jni, AttachCurrentThreadAsDaemon__entry, vm, penv, _args);
 #else /* USDT2 */
-  HOTSPOT_JNI_ATTACHCURRENTTHREADASDAEMON_ENTRY(
-                                                vm, penv, _args);
+  HOTSPOT_JNI_ATTACHCURRENTTHREADASDAEMON_ENTRY(vm, penv, _args);
 #endif /* USDT2 */
   if (!vm_created) {
 #ifndef USDT2
     DTRACE_PROBE1(hotspot_jni, AttachCurrentThreadAsDaemon__return, JNI_ERR);
 #else /* USDT2 */
-  HOTSPOT_JNI_ATTACHCURRENTTHREADASDAEMON_RETURN(
-                                                 (uint32_t) JNI_ERR);
+  HOTSPOT_JNI_ATTACHCURRENTTHREADASDAEMON_RETURN((uint32_t) JNI_ERR);
 #endif /* USDT2 */
     return JNI_ERR;
   }
@@ -5665,8 +5535,7 @@
 #ifndef USDT2
   DTRACE_PROBE1(hotspot_jni, AttachCurrentThreadAsDaemon__return, ret);
 #else /* USDT2 */
-  HOTSPOT_JNI_ATTACHCURRENTTHREADASDAEMON_RETURN(
-                                                 ret);
+  HOTSPOT_JNI_ATTACHCURRENTTHREADASDAEMON_RETURN(ret);
 #endif /* USDT2 */
   return ret;
 }
Index: jdk/src/macosx/native/sun/awt/AWTView.m
<+>UTF-8
===================================================================
diff --git a/jdk/src/macosx/native/sun/awt/AWTView.m b/jdk/src/macosx/native/sun/awt/AWTView.m
--- a/jdk/src/macosx/native/sun/awt/AWTView.m	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/jdk/src/macosx/native/sun/awt/AWTView.m	(date 1708512692218)
@@ -37,7 +37,6 @@
 #import "JavaTextAccessibility.h"
 #import "JavaAccessibilityUtilities.h"
 #import "GeomUtilities.h"
-#import "OSVersion.h"
 #import "CGLLayer.h"
 
 @interface AWTView()
@@ -54,13 +53,6 @@
 //#define IM_DEBUG TRUE
 //#define EXTRA_DEBUG
 
-static BOOL shouldUsePressAndHold() {
-    static int shouldUsePressAndHold = -1;
-    if (shouldUsePressAndHold != -1) return shouldUsePressAndHold;
-    shouldUsePressAndHold = !isSnowLeopardOrLower();
-    return shouldUsePressAndHold;
-}
-
 @implementation AWTView
 
 @synthesize _dropTarget;
@@ -83,7 +75,7 @@
     fKeyEventsNeeded = NO;
     fProcessingKeystroke = NO;
 
-    fEnablePressAndHold = shouldUsePressAndHold();
+    fEnablePressAndHold = fEnablePressAndHold = YES;
     fInPressAndHold = NO;
     fPAHNeedsToSelect = NO;
 
Index: hotspot/make/solaris/makefiles/top.make
<+>UTF-8
===================================================================
diff --git a/hotspot/make/solaris/makefiles/top.make b/hotspot/make/solaris/makefiles/top.make
--- a/hotspot/make/solaris/makefiles/top.make	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/hotspot/make/solaris/makefiles/top.make	(date 1708515520181)
@@ -73,7 +73,7 @@
 	@echo All done.
 
 # This is an explicit dependency for the sake of parallel makes.
-vm_build_preliminaries:  checks $(Cached_plat) $(AD_Files_If_Required) jvmti_stuff jfr_stuff sa_stuff
+vm_build_preliminaries:  checks $(Cached_plat) $(AD_Files_If_Required) jvmti_stuff jfr_stuff sa_stuff dtrace_stuff
 	@# We need a null action here, so implicit rules don't get consulted.
 
 $(Cached_plat): $(Plat_File)
@@ -95,6 +95,9 @@
 sa_stuff:
 	@$(MAKE) -f sa.make $(MFLAGS-adjusted)
 
+dtrace_stuff: $(Cached_plat) $(adjust-mflags)
+	@$(MAKE) -f dtrace.make dtrace_gen_headers $(MFLAGS-adjusted) GENERATED=$(GENERATED)
+
 # and the VM: must use other makefile with dependencies included
 
 # We have to go to great lengths to get control over the -jN argument
Index: hotspot/src/share/vm/code/compiledIC.cpp
<+>UTF-8
===================================================================
diff --git a/hotspot/src/share/vm/code/compiledIC.cpp b/hotspot/src/share/vm/code/compiledIC.cpp
--- a/hotspot/src/share/vm/code/compiledIC.cpp	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/hotspot/src/share/vm/code/compiledIC.cpp	(date 1708509097579)
@@ -222,7 +222,7 @@
     assert(bytecode == Bytecodes::_invokeinterface, "");
     int itable_index = call_info->itable_index();
     entry = VtableStubs::find_itable_stub(itable_index);
-    if (entry == false) {
+    if (entry == NULL) {
       return false;
     }
 #ifdef ASSERT
Index: hotspot/make/solaris/makefiles/buildtree.make
<+>UTF-8
===================================================================
diff --git a/hotspot/make/solaris/makefiles/buildtree.make b/hotspot/make/solaris/makefiles/buildtree.make
--- a/hotspot/make/solaris/makefiles/buildtree.make	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/hotspot/make/solaris/makefiles/buildtree.make	(date 1708515400489)
@@ -122,7 +122,7 @@
 # For dependencies and recursive makes.
 BUILDTREE_MAKE	= $(GAMMADIR)/make/$(OS_FAMILY)/makefiles/buildtree.make
 
-BUILDTREE_TARGETS = Makefile flags.make flags_vm.make vm.make adlc.make jvmti.make jfr.make sa.make
+BUILDTREE_TARGETS = Makefile flags.make flags_vm.make vm.make adlc.make jvmti.make jfr.make sa.make dtrace.make
 
 BUILDTREE_VARS	= GAMMADIR=$(GAMMADIR) OS_FAMILY=$(OS_FAMILY) \
 	ARCH=$(ARCH) BUILDARCH=$(BUILDARCH) LIBARCH=$(LIBARCH) VARIANT=$(VARIANT)
@@ -369,6 +369,16 @@
 	echo; \
 	echo "include \$$(GAMMADIR)/make/$(OS_FAMILY)/makefiles/$(@F)"; \
 	) > $@
+
+dtrace.make: $(BUILDTREE_MAKE)
+	@echo Creating $@ ...
+	$(QUIETLY) ( \
+	$(BUILDTREE_COMMENT); \
+	echo; \
+	echo include flags.make; \
+	echo; \
+	echo "include \$$(GAMMADIR)/make/$(OS_FAMILY)/makefiles/$(@F)"; \
+	) > $@
 
 FORCE:
 
Index: hotspot/src/share/vm/gc_implementation/concurrentMarkSweep/vmCMSOperations.cpp
<+>UTF-8
===================================================================
diff --git a/hotspot/src/share/vm/gc_implementation/concurrentMarkSweep/vmCMSOperations.cpp b/hotspot/src/share/vm/gc_implementation/concurrentMarkSweep/vmCMSOperations.cpp
--- a/hotspot/src/share/vm/gc_implementation/concurrentMarkSweep/vmCMSOperations.cpp	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/hotspot/src/share/vm/gc_implementation/concurrentMarkSweep/vmCMSOperations.cpp	(date 1708515743308)
@@ -146,8 +146,7 @@
 #ifndef USDT2
   HS_DTRACE_PROBE(hs_private, cms__initmark__begin);
 #else /* USDT2 */
-  HS_PRIVATE_CMS_INITMARK_BEGIN(
-                                );
+  HS_PRIVATE_CMS_INITMARK_BEGIN();
 #endif /* USDT2 */
 
   _collector->_gc_timer_cm->register_gc_pause_start("Initial Mark");
@@ -167,8 +166,7 @@
 #ifndef USDT2
   HS_DTRACE_PROBE(hs_private, cms__initmark__end);
 #else /* USDT2 */
-  HS_PRIVATE_CMS_INITMARK_END(
-                                );
+  HS_PRIVATE_CMS_INITMARK_END();
 #endif /* USDT2 */
 }
 
@@ -183,8 +181,7 @@
 #ifndef USDT2
   HS_DTRACE_PROBE(hs_private, cms__remark__begin);
 #else /* USDT2 */
-  HS_PRIVATE_CMS_REMARK_BEGIN(
-                                );
+  HS_PRIVATE_CMS_REMARK_BEGIN();
 #endif /* USDT2 */
 
   _collector->_gc_timer_cm->register_gc_pause_start("Final Mark");
@@ -205,8 +202,7 @@
 #ifndef USDT2
   HS_DTRACE_PROBE(hs_private, cms__remark__end);
 #else /* USDT2 */
-  HS_PRIVATE_CMS_REMARK_END(
-                                );
+  HS_PRIVATE_CMS_REMARK_END();
 #endif /* USDT2 */
 }
 
Index: hotspot/src/os_cpu/bsd_zero/vm/os_bsd_zero.cpp
<+>UTF-8
===================================================================
diff --git a/hotspot/src/os_cpu/bsd_zero/vm/os_bsd_zero.cpp b/hotspot/src/os_cpu/bsd_zero/vm/os_bsd_zero.cpp
--- a/hotspot/src/os_cpu/bsd_zero/vm/os_bsd_zero.cpp	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/hotspot/src/os_cpu/bsd_zero/vm/os_bsd_zero.cpp	(date 1708512003433)
@@ -381,42 +381,42 @@
     return 1;
   }
 
-  void _Copy_conjoint_jshorts_atomic(jshort* from, jshort* to, size_t count) {
+  void _Copy_conjoint_jshorts_atomic(const jshort* from, jshort* to, size_t count) {
     if (from > to) {
-      jshort *end = from + count;
+      const jshort *end = from + count;
       while (from < end)
         *(to++) = *(from++);
     }
     else if (from < to) {
-      jshort *end = from;
+      const jshort *end = from + count;
       from += count - 1;
       to   += count - 1;
       while (from >= end)
         *(to--) = *(from--);
     }
   }
-  void _Copy_conjoint_jints_atomic(jint* from, jint* to, size_t count) {
+  void _Copy_conjoint_jints_atomic(const jint* from, jint* to, size_t count) {
     if (from > to) {
-      jint *end = from + count;
+      const jint *end = from + count;
       while (from < end)
         *(to++) = *(from++);
     }
     else if (from < to) {
-      jint *end = from;
+      const jint *end = from;
       from += count - 1;
       to   += count - 1;
       while (from >= end)
         *(to--) = *(from--);
     }
   }
-  void _Copy_conjoint_jlongs_atomic(jlong* from, jlong* to, size_t count) {
+  void _Copy_conjoint_jlongs_atomic(const jlong* from, jlong* to, size_t count) {
     if (from > to) {
-      jlong *end = from + count;
+      const jlong *end = from + count;
       while (from < end)
         os::atomic_copy64(from++, to++);
     }
     else if (from < to) {
-      jlong *end = from;
+      const jlong *end = from;
       from += count - 1;
       to   += count - 1;
       while (from >= end)
@@ -424,22 +424,22 @@
     }
   }
 
-  void _Copy_arrayof_conjoint_bytes(HeapWord* from,
+  void _Copy_arrayof_conjoint_bytes(const HeapWord* from,
                                     HeapWord* to,
                                     size_t    count) {
     memmove(to, from, count);
   }
-  void _Copy_arrayof_conjoint_jshorts(HeapWord* from,
+  void _Copy_arrayof_conjoint_jshorts(const HeapWord* from,
                                       HeapWord* to,
                                       size_t    count) {
     memmove(to, from, count * 2);
   }
-  void _Copy_arrayof_conjoint_jints(HeapWord* from,
+  void _Copy_arrayof_conjoint_jints(const HeapWord* from,
                                     HeapWord* to,
                                     size_t    count) {
     memmove(to, from, count * 4);
   }
-  void _Copy_arrayof_conjoint_jlongs(HeapWord* from,
+  void _Copy_arrayof_conjoint_jlongs(const HeapWord* from,
                                      HeapWord* to,
                                      size_t    count) {
     memmove(to, from, count * 8);
Index: hotspot/src/os/bsd/dtrace/hotspot.d
<+>UTF-8
===================================================================
diff --git a/hotspot/src/os/bsd/dtrace/hotspot.d b/hotspot/src/os/bsd/dtrace/hotspot.d
--- a/hotspot/src/os/bsd/dtrace/hotspot.d	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/hotspot/src/os/bsd/dtrace/hotspot.d	(date 1708515549265)
@@ -56,7 +56,7 @@
   probe thread__park__end(uintptr_t);
   probe thread__unpark(uintptr_t);
   probe method__compile__begin(
-    const char*, uintptr_t, const char*, uintptr_t, const char*, uintptr_t, const char*, uintptr_t); 
+    char*, uintptr_t, char*, uintptr_t, char*, uintptr_t, char*, uintptr_t);
   probe method__compile__end(
     char*, uintptr_t, char*, uintptr_t, char*, uintptr_t, 
     char*, uintptr_t, uintptr_t); 
Index: hotspot/make/solaris/makefiles/dtrace.make
<+>UTF-8
===================================================================
diff --git a/hotspot/make/solaris/makefiles/dtrace.make b/hotspot/make/solaris/makefiles/dtrace.make
--- a/hotspot/make/solaris/makefiles/dtrace.make	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/hotspot/make/solaris/makefiles/dtrace.make	(date 1708515453159)
@@ -36,6 +36,8 @@
 
 else
 
+DtraceOutDir = $(GENERATED)/dtracefiles
+
 JVM_DB = libjvm_db
 LIBJVM_DB = libjvm_db.so
 
@@ -305,6 +307,22 @@
 	$(QUIETLY) if [ -f $(GENOFFS) ]; then touch $(GENOFFS); fi
 	$(QUIETLY) if [ -f $(JVMOFFS.o) ]; then touch $(JVMOFFS.o); fi
 
+
+$(DtraceOutDir):
+	mkdir $(DtraceOutDir)
+
+$(DtraceOutDir)/hotspot.h: $(DTRACE_SRCDIR)/hotspot.d | $(DtraceOutDir)
+	$(QUIETLY) $(DTRACE_PROG) $(DTRACE_OPTS) -C -I. -h -o $@ -s $(DTRACE_SRCDIR)/hotspot.d
+
+$(DtraceOutDir)/hotspot_jni.h: $(DTRACE_SRCDIR)/hotspot_jni.d | $(DtraceOutDir)
+	$(QUIETLY) $(DTRACE_PROG) $(DTRACE_OPTS) -C -I. -h -o $@ -s $(DTRACE_SRCDIR)/hotspot_jni.d
+
+$(DtraceOutDir)/hs_private.h: $(DTRACE_SRCDIR)/hs_private.d | $(DtraceOutDir)
+	$(QUIETLY) $(DTRACE_PROG) $(DTRACE_OPTS) -C -I. -h -o $@ -s $(DTRACE_SRCDIR)/hs_private.d
+
+dtrace_gen_headers: $(DtraceOutDir)/hotspot.h $(DtraceOutDir)/hotspot_jni.h $(DtraceOutDir)/hs_private.h
+
+
 .PHONY: dtraceCheck
 
 SYSTEM_DTRACE_H = /usr/include/dtrace.h
Index: hotspot/src/cpu/zero/vm/cppInterpreter_zero.cpp
<+>UTF-8
===================================================================
diff --git a/hotspot/src/cpu/zero/vm/cppInterpreter_zero.cpp b/hotspot/src/cpu/zero/vm/cppInterpreter_zero.cpp
--- a/hotspot/src/cpu/zero/vm/cppInterpreter_zero.cpp	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/hotspot/src/cpu/zero/vm/cppInterpreter_zero.cpp	(date 1708511712770)
@@ -370,7 +370,7 @@
 
   // Make the call
   intptr_t result[4 - LogBytesPerWord];
-  ffi_call(handler->cif(), (void (*)()) function, result, arguments);
+  ffi_call(handler->cif(), CAST_TO_FN_PTR(void (*)(), function), result, arguments);
 
   // Change the thread state back to _thread_in_Java.
   // ThreadStateTransition::transition_from_native() cannot be used
Index: jdk/src/macosx/bin/zero/jvm.cfg
<+>UTF-8
===================================================================
diff --git a/jdk/src/macosx/bin/zero/jvm.cfg b/jdk/src/macosx/bin/zero/jvm.cfg
new file mode 100644
--- /dev/null	(date 1708511243896)
+++ b/jdk/src/macosx/bin/zero/jvm.cfg	(date 1708511243896)
@@ -0,0 +1,35 @@
+# Copyright (c) 2009, 2013, Oracle and/or its affiliates. All rights reserved.
+# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
+#
+# This code is free software; you can redistribute it and/or modify it
+# under the terms of the GNU General Public License version 2 only, as
+# published by the Free Software Foundation.  Oracle designates this
+# particular file as subject to the "Classpath" exception as provided
+# by Oracle in the LICENSE file that accompanied this code.
+#
+# This code is distributed in the hope that it will be useful, but WITHOUT
+# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+# version 2 for more details (a copy is included in the LICENSE file that
+# accompanied this code).
+#
+# You should have received a copy of the GNU General Public License version
+# 2 along with this work; if not, write to the Free Software Foundation,
+# Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
+#
+# Please contact Oracle, 500 Oracle Parkway, Redwood Shores, CA 94065 USA
+# or visit www.oracle.com if you need additional information or have any
+# questions.
+#
+#
+# List of JVMs that can be used as an option to java, javac, etc.
+# Order is important -- first in this list is the default JVM.
+# NOTE that this both this file and its format are UNSUPPORTED and
+# WILL GO AWAY in a future release.
+#
+# You may also select a JVM in an arbitrary location with the
+# "-XXaltjvm=<jvm_dir>" option, but that too is unsupported
+# and may not be available in a future release.
+#
+-server KNOWN
+-client IGNORE
Index: hotspot/src/os/solaris/dtrace/hotspot.d
<+>UTF-8
===================================================================
diff --git a/hotspot/src/os/solaris/dtrace/hotspot.d b/hotspot/src/os/solaris/dtrace/hotspot.d
--- a/hotspot/src/os/solaris/dtrace/hotspot.d	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/hotspot/src/os/solaris/dtrace/hotspot.d	(date 1708515581148)
@@ -25,7 +25,7 @@
 provider hotspot {
   probe class__loaded(char*, uintptr_t, void*, uintptr_t);
   probe class__unloaded(char*, uintptr_t, void*, uintptr_t);
-  probe class__initialization__required(char*, uintptr_t, void*, intptr_t,int);
+  probe class__initialization__required(char*, uintptr_t, void*, intptr_t);
   probe class__initialization__recursive(char*, uintptr_t, void*, intptr_t,int);
   probe class__initialization__concurrent(char*, uintptr_t, void*, intptr_t,int);
   probe class__initialization__erroneous(char*, uintptr_t, void*, intptr_t, int);
Index: hotspot/src/os/solaris/dtrace/hotspot_jni.d
<+>UTF-8
===================================================================
diff --git a/hotspot/src/os/solaris/dtrace/hotspot_jni.d b/hotspot/src/os/solaris/dtrace/hotspot_jni.d
--- a/hotspot/src/os/solaris/dtrace/hotspot_jni.d	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/hotspot/src/os/solaris/dtrace/hotspot_jni.d	(date 1708515629936)
@@ -211,7 +211,7 @@
   probe CallVoidMethodV__return();
   probe CreateJavaVM__entry(void**, void**, void*);
   probe CreateJavaVM__return(uint32_t);
-  probe DefineClass__entry(void*, const char*, void*, char, uintptr_t);
+  probe DefineClass__entry(void*, const char*, void*, char*, uintptr_t);
   probe DefineClass__return(void*);
   probe DeleteGlobalRef__entry(void*, void*);
   probe DeleteGlobalRef__return();
Index: hotspot/src/share/vm/runtime/stubRoutines.cpp
<+>UTF-8
===================================================================
diff --git a/hotspot/src/share/vm/runtime/stubRoutines.cpp b/hotspot/src/share/vm/runtime/stubRoutines.cpp
--- a/hotspot/src/share/vm/runtime/stubRoutines.cpp	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/hotspot/src/share/vm/runtime/stubRoutines.cpp	(date 1708512500793)
@@ -201,18 +201,21 @@
   // Use middle of array to check that memory before it is not modified.
   address buffer  = (address) round_to((intptr_t)&lbuffer[4], BytesPerLong);
   address buffer2 = (address) round_to((intptr_t)&lbuffer2[4], BytesPerLong);
+
+  arraycopy_fn copyfunc = CAST_TO_FN_PTR(arraycopy_fn, func);
+
   // do an aligned copy
-  ((arraycopy_fn)func)(buffer, buffer2, 0);
+  copyfunc(buffer, buffer2, 0);
   for (i = 0; i < sizeof(lbuffer); i++) {
     assert(fbuffer[i] == v && fbuffer2[i] == v2, "shouldn't have copied anything");
   }
   // adjust destination alignment
-  ((arraycopy_fn)func)(buffer, buffer2 + alignment, 0);
+  copyfunc(buffer, buffer2 + alignment, 0);
   for (i = 0; i < sizeof(lbuffer); i++) {
     assert(fbuffer[i] == v && fbuffer2[i] == v2, "shouldn't have copied anything");
   }
   // adjust source alignment
-  ((arraycopy_fn)func)(buffer + alignment, buffer2, 0);
+  copyfunc(buffer + alignment, buffer2, 0);
   for (i = 0; i < sizeof(lbuffer); i++) {
     assert(fbuffer[i] == v && fbuffer2[i] == v2, "shouldn't have copied anything");
   }
Index: jdk/src/macosx/native/com/sun/media/sound/PLATFORM_API_MacOSX_Ports.cpp
<+>UTF-8
===================================================================
diff --git a/jdk/src/macosx/native/com/sun/media/sound/PLATFORM_API_MacOSX_Ports.cpp b/jdk/src/macosx/native/com/sun/media/sound/PLATFORM_API_MacOSX_Ports.cpp
--- a/jdk/src/macosx/native/com/sun/media/sound/PLATFORM_API_MacOSX_Ports.cpp	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/jdk/src/macosx/native/com/sun/media/sound/PLATFORM_API_MacOSX_Ports.cpp	(date 1708603171166)
@@ -609,7 +609,7 @@
                 // get the channel name
                 char *channelName;
                 CFStringRef cfname = NULL;
-                const AudioObjectPropertyAddress address = {kAudioObjectPropertyElementName, port->scope, ch};
+                const AudioObjectPropertyAddress address = {kAudioObjectPropertyElementName, port->scope, (unsigned)ch};
                 UInt32 size = sizeof(cfname);
                 OSStatus err = AudioObjectGetPropertyData(mixer->deviceID, &address, 0, NULL, &size, &cfname);
                 if (err == noErr) {
Index: common/autoconf/generated-configure.sh
<+>UTF-8
===================================================================
diff --git a/common/autoconf/generated-configure.sh b/common/autoconf/generated-configure.sh
--- a/common/autoconf/generated-configure.sh	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/common/autoconf/generated-configure.sh	(date 1708511578478)
@@ -13865,10 +13865,20 @@
       VAR_CPU_ENDIAN=little
       ;;
     arm*)
-      VAR_CPU=arm
-      VAR_CPU_ARCH=arm
-      VAR_CPU_BITS=32
-      VAR_CPU_ENDIAN=little
+      case "$2" in
+        *darwin*)
+          VAR_CPU=aarch64
+          VAR_CPU_ARCH=aarch64
+          VAR_CPU_BITS=64
+          VAR_CPU_ENDIAN=little
+        ;;
+        *)
+          VAR_CPU=arm
+          VAR_CPU_ARCH=arm
+          VAR_CPU_BITS=32
+          VAR_CPU_ENDIAN=little
+        ;;
+      esac
       ;;
     aarch64)
       VAR_CPU=aarch64
@@ -14003,10 +14013,20 @@
       VAR_CPU_ENDIAN=little
       ;;
     arm*)
-      VAR_CPU=arm
-      VAR_CPU_ARCH=arm
-      VAR_CPU_BITS=32
-      VAR_CPU_ENDIAN=little
+     case "$2" in
+       *darwin*)
+         VAR_CPU=aarch64
+         VAR_CPU_ARCH=aarch64
+         VAR_CPU_BITS=64
+         VAR_CPU_ENDIAN=little
+       ;;
+       *)
+         VAR_CPU=arm
+         VAR_CPU_ARCH=arm
+         VAR_CPU_BITS=32
+         VAR_CPU_ENDIAN=little
+       ;;
+     esac
       ;;
     aarch64)
       VAR_CPU=aarch64
@@ -20552,7 +20572,7 @@
             BOOT_JDK_FOUND=no
           else
             # Oh, this is looking good! We probably have found a proper JDK. Is it the correct version?
-            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | head -n 1`
+            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | head -n 1`
 
             # Extra M4 quote needed to protect [] in grep expression.
             FOUND_VERSION_78=`echo $BOOT_JDK_VERSION | grep  '\"1\.[78]\.'`
@@ -20704,7 +20724,7 @@
 $as_echo "$BOOT_JDK" >&6; }
               { $as_echo "$as_me:${as_lineno-$LINENO}: checking Boot JDK version" >&5
 $as_echo_n "checking Boot JDK version... " >&6; }
-              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | $TR '\n\r' '  '`
+              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | $TR '\n\r' '  '`
               { $as_echo "$as_me:${as_lineno-$LINENO}: result: $BOOT_JDK_VERSION" >&5
 $as_echo "$BOOT_JDK_VERSION" >&6; }
             fi # end check jdk version
@@ -20895,7 +20915,7 @@
             BOOT_JDK_FOUND=no
           else
             # Oh, this is looking good! We probably have found a proper JDK. Is it the correct version?
-            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | head -n 1`
+            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | head -n 1`
 
             # Extra M4 quote needed to protect [] in grep expression.
             FOUND_VERSION_78=`echo $BOOT_JDK_VERSION | grep  '\"1\.[78]\.'`
@@ -21047,7 +21067,7 @@
 $as_echo "$BOOT_JDK" >&6; }
               { $as_echo "$as_me:${as_lineno-$LINENO}: checking Boot JDK version" >&5
 $as_echo_n "checking Boot JDK version... " >&6; }
-              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | $TR '\n\r' '  '`
+              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | $TR '\n\r' '  '`
               { $as_echo "$as_me:${as_lineno-$LINENO}: result: $BOOT_JDK_VERSION" >&5
 $as_echo "$BOOT_JDK_VERSION" >&6; }
             fi # end check jdk version
@@ -21235,7 +21255,7 @@
             BOOT_JDK_FOUND=no
           else
             # Oh, this is looking good! We probably have found a proper JDK. Is it the correct version?
-            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | head -n 1`
+            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | head -n 1`
 
             # Extra M4 quote needed to protect [] in grep expression.
             FOUND_VERSION_78=`echo $BOOT_JDK_VERSION | grep  '\"1\.[78]\.'`
@@ -21387,7 +21407,7 @@
 $as_echo "$BOOT_JDK" >&6; }
               { $as_echo "$as_me:${as_lineno-$LINENO}: checking Boot JDK version" >&5
 $as_echo_n "checking Boot JDK version... " >&6; }
-              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | $TR '\n\r' '  '`
+              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | $TR '\n\r' '  '`
               { $as_echo "$as_me:${as_lineno-$LINENO}: result: $BOOT_JDK_VERSION" >&5
 $as_echo "$BOOT_JDK_VERSION" >&6; }
             fi # end check jdk version
@@ -21434,7 +21454,7 @@
             BOOT_JDK_FOUND=no
           else
             # Oh, this is looking good! We probably have found a proper JDK. Is it the correct version?
-            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | head -n 1`
+            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | head -n 1`
 
             # Extra M4 quote needed to protect [] in grep expression.
             FOUND_VERSION_78=`echo $BOOT_JDK_VERSION | grep  '\"1\.[78]\.'`
@@ -21586,7 +21606,7 @@
 $as_echo "$BOOT_JDK" >&6; }
               { $as_echo "$as_me:${as_lineno-$LINENO}: checking Boot JDK version" >&5
 $as_echo_n "checking Boot JDK version... " >&6; }
-              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | $TR '\n\r' '  '`
+              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | $TR '\n\r' '  '`
               { $as_echo "$as_me:${as_lineno-$LINENO}: result: $BOOT_JDK_VERSION" >&5
 $as_echo "$BOOT_JDK_VERSION" >&6; }
             fi # end check jdk version
@@ -21773,7 +21793,7 @@
             BOOT_JDK_FOUND=no
           else
             # Oh, this is looking good! We probably have found a proper JDK. Is it the correct version?
-            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | head -n 1`
+            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | head -n 1`
 
             # Extra M4 quote needed to protect [] in grep expression.
             FOUND_VERSION_78=`echo $BOOT_JDK_VERSION | grep  '\"1\.[78]\.'`
@@ -21925,7 +21945,7 @@
 $as_echo "$BOOT_JDK" >&6; }
               { $as_echo "$as_me:${as_lineno-$LINENO}: checking Boot JDK version" >&5
 $as_echo_n "checking Boot JDK version... " >&6; }
-              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | $TR '\n\r' '  '`
+              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | $TR '\n\r' '  '`
               { $as_echo "$as_me:${as_lineno-$LINENO}: result: $BOOT_JDK_VERSION" >&5
 $as_echo "$BOOT_JDK_VERSION" >&6; }
             fi # end check jdk version
@@ -21999,7 +22019,7 @@
             BOOT_JDK_FOUND=no
           else
             # Oh, this is looking good! We probably have found a proper JDK. Is it the correct version?
-            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | head -n 1`
+            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | head -n 1`
 
             # Extra M4 quote needed to protect [] in grep expression.
             FOUND_VERSION_78=`echo $BOOT_JDK_VERSION | grep  '\"1\.[78]\.'`
@@ -22151,7 +22171,7 @@
 $as_echo "$BOOT_JDK" >&6; }
               { $as_echo "$as_me:${as_lineno-$LINENO}: checking Boot JDK version" >&5
 $as_echo_n "checking Boot JDK version... " >&6; }
-              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | $TR '\n\r' '  '`
+              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | $TR '\n\r' '  '`
               { $as_echo "$as_me:${as_lineno-$LINENO}: result: $BOOT_JDK_VERSION" >&5
 $as_echo "$BOOT_JDK_VERSION" >&6; }
             fi # end check jdk version
@@ -22190,7 +22210,7 @@
             BOOT_JDK_FOUND=no
           else
             # Oh, this is looking good! We probably have found a proper JDK. Is it the correct version?
-            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | head -n 1`
+            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | head -n 1`
 
             # Extra M4 quote needed to protect [] in grep expression.
             FOUND_VERSION_78=`echo $BOOT_JDK_VERSION | grep  '\"1\.[78]\.'`
@@ -22342,7 +22362,7 @@
 $as_echo "$BOOT_JDK" >&6; }
               { $as_echo "$as_me:${as_lineno-$LINENO}: checking Boot JDK version" >&5
 $as_echo_n "checking Boot JDK version... " >&6; }
-              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | $TR '\n\r' '  '`
+              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | $TR '\n\r' '  '`
               { $as_echo "$as_me:${as_lineno-$LINENO}: result: $BOOT_JDK_VERSION" >&5
 $as_echo "$BOOT_JDK_VERSION" >&6; }
             fi # end check jdk version
@@ -22409,7 +22429,7 @@
             BOOT_JDK_FOUND=no
           else
             # Oh, this is looking good! We probably have found a proper JDK. Is it the correct version?
-            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | head -n 1`
+            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | head -n 1`
 
             # Extra M4 quote needed to protect [] in grep expression.
             FOUND_VERSION_78=`echo $BOOT_JDK_VERSION | grep  '\"1\.[78]\.'`
@@ -22561,7 +22581,7 @@
 $as_echo "$BOOT_JDK" >&6; }
               { $as_echo "$as_me:${as_lineno-$LINENO}: checking Boot JDK version" >&5
 $as_echo_n "checking Boot JDK version... " >&6; }
-              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | $TR '\n\r' '  '`
+              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | $TR '\n\r' '  '`
               { $as_echo "$as_me:${as_lineno-$LINENO}: result: $BOOT_JDK_VERSION" >&5
 $as_echo "$BOOT_JDK_VERSION" >&6; }
             fi # end check jdk version
@@ -22600,7 +22620,7 @@
             BOOT_JDK_FOUND=no
           else
             # Oh, this is looking good! We probably have found a proper JDK. Is it the correct version?
-            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | head -n 1`
+            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | head -n 1`
 
             # Extra M4 quote needed to protect [] in grep expression.
             FOUND_VERSION_78=`echo $BOOT_JDK_VERSION | grep  '\"1\.[78]\.'`
@@ -22752,7 +22772,7 @@
 $as_echo "$BOOT_JDK" >&6; }
               { $as_echo "$as_me:${as_lineno-$LINENO}: checking Boot JDK version" >&5
 $as_echo_n "checking Boot JDK version... " >&6; }
-              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | $TR '\n\r' '  '`
+              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | $TR '\n\r' '  '`
               { $as_echo "$as_me:${as_lineno-$LINENO}: result: $BOOT_JDK_VERSION" >&5
 $as_echo "$BOOT_JDK_VERSION" >&6; }
             fi # end check jdk version
@@ -22819,7 +22839,7 @@
             BOOT_JDK_FOUND=no
           else
             # Oh, this is looking good! We probably have found a proper JDK. Is it the correct version?
-            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | head -n 1`
+            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | head -n 1`
 
             # Extra M4 quote needed to protect [] in grep expression.
             FOUND_VERSION_78=`echo $BOOT_JDK_VERSION | grep  '\"1\.[78]\.'`
@@ -22971,7 +22991,7 @@
 $as_echo "$BOOT_JDK" >&6; }
               { $as_echo "$as_me:${as_lineno-$LINENO}: checking Boot JDK version" >&5
 $as_echo_n "checking Boot JDK version... " >&6; }
-              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | $TR '\n\r' '  '`
+              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | $TR '\n\r' '  '`
               { $as_echo "$as_me:${as_lineno-$LINENO}: result: $BOOT_JDK_VERSION" >&5
 $as_echo "$BOOT_JDK_VERSION" >&6; }
             fi # end check jdk version
@@ -23010,7 +23030,7 @@
             BOOT_JDK_FOUND=no
           else
             # Oh, this is looking good! We probably have found a proper JDK. Is it the correct version?
-            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | head -n 1`
+            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | head -n 1`
 
             # Extra M4 quote needed to protect [] in grep expression.
             FOUND_VERSION_78=`echo $BOOT_JDK_VERSION | grep  '\"1\.[78]\.'`
@@ -23162,7 +23182,7 @@
 $as_echo "$BOOT_JDK" >&6; }
               { $as_echo "$as_me:${as_lineno-$LINENO}: checking Boot JDK version" >&5
 $as_echo_n "checking Boot JDK version... " >&6; }
-              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | $TR '\n\r' '  '`
+              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | $TR '\n\r' '  '`
               { $as_echo "$as_me:${as_lineno-$LINENO}: result: $BOOT_JDK_VERSION" >&5
 $as_echo "$BOOT_JDK_VERSION" >&6; }
             fi # end check jdk version
@@ -23229,7 +23249,7 @@
             BOOT_JDK_FOUND=no
           else
             # Oh, this is looking good! We probably have found a proper JDK. Is it the correct version?
-            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | head -n 1`
+            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | head -n 1`
 
             # Extra M4 quote needed to protect [] in grep expression.
             FOUND_VERSION_78=`echo $BOOT_JDK_VERSION | grep  '\"1\.[78]\.'`
@@ -23381,7 +23401,7 @@
 $as_echo "$BOOT_JDK" >&6; }
               { $as_echo "$as_me:${as_lineno-$LINENO}: checking Boot JDK version" >&5
 $as_echo_n "checking Boot JDK version... " >&6; }
-              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | $TR '\n\r' '  '`
+              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | $TR '\n\r' '  '`
               { $as_echo "$as_me:${as_lineno-$LINENO}: result: $BOOT_JDK_VERSION" >&5
 $as_echo "$BOOT_JDK_VERSION" >&6; }
             fi # end check jdk version
@@ -23420,7 +23440,7 @@
             BOOT_JDK_FOUND=no
           else
             # Oh, this is looking good! We probably have found a proper JDK. Is it the correct version?
-            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | head -n 1`
+            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | head -n 1`
 
             # Extra M4 quote needed to protect [] in grep expression.
             FOUND_VERSION_78=`echo $BOOT_JDK_VERSION | grep  '\"1\.[78]\.'`
@@ -23572,7 +23592,7 @@
 $as_echo "$BOOT_JDK" >&6; }
               { $as_echo "$as_me:${as_lineno-$LINENO}: checking Boot JDK version" >&5
 $as_echo_n "checking Boot JDK version... " >&6; }
-              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | $TR '\n\r' '  '`
+              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | $TR '\n\r' '  '`
               { $as_echo "$as_me:${as_lineno-$LINENO}: result: $BOOT_JDK_VERSION" >&5
 $as_echo "$BOOT_JDK_VERSION" >&6; }
             fi # end check jdk version
@@ -23626,7 +23646,7 @@
             BOOT_JDK_FOUND=no
           else
             # Oh, this is looking good! We probably have found a proper JDK. Is it the correct version?
-            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | head -n 1`
+            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | head -n 1`
 
             # Extra M4 quote needed to protect [] in grep expression.
             FOUND_VERSION_78=`echo $BOOT_JDK_VERSION | grep  '\"1\.[78]\.'`
@@ -23778,7 +23798,7 @@
 $as_echo "$BOOT_JDK" >&6; }
               { $as_echo "$as_me:${as_lineno-$LINENO}: checking Boot JDK version" >&5
 $as_echo_n "checking Boot JDK version... " >&6; }
-              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | $TR '\n\r' '  '`
+              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | $TR '\n\r' '  '`
               { $as_echo "$as_me:${as_lineno-$LINENO}: result: $BOOT_JDK_VERSION" >&5
 $as_echo "$BOOT_JDK_VERSION" >&6; }
             fi # end check jdk version
@@ -23815,7 +23835,7 @@
             BOOT_JDK_FOUND=no
           else
             # Oh, this is looking good! We probably have found a proper JDK. Is it the correct version?
-            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | head -n 1`
+            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | head -n 1`
 
             # Extra M4 quote needed to protect [] in grep expression.
             FOUND_VERSION_78=`echo $BOOT_JDK_VERSION | grep  '\"1\.[78]\.'`
@@ -23967,7 +23987,7 @@
 $as_echo "$BOOT_JDK" >&6; }
               { $as_echo "$as_me:${as_lineno-$LINENO}: checking Boot JDK version" >&5
 $as_echo_n "checking Boot JDK version... " >&6; }
-              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | $TR '\n\r' '  '`
+              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | $TR '\n\r' '  '`
               { $as_echo "$as_me:${as_lineno-$LINENO}: result: $BOOT_JDK_VERSION" >&5
 $as_echo "$BOOT_JDK_VERSION" >&6; }
             fi # end check jdk version
@@ -24022,7 +24042,7 @@
             BOOT_JDK_FOUND=no
           else
             # Oh, this is looking good! We probably have found a proper JDK. Is it the correct version?
-            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | head -n 1`
+            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | head -n 1`
 
             # Extra M4 quote needed to protect [] in grep expression.
             FOUND_VERSION_78=`echo $BOOT_JDK_VERSION | grep  '\"1\.[78]\.'`
@@ -24174,7 +24194,7 @@
 $as_echo "$BOOT_JDK" >&6; }
               { $as_echo "$as_me:${as_lineno-$LINENO}: checking Boot JDK version" >&5
 $as_echo_n "checking Boot JDK version... " >&6; }
-              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | $TR '\n\r' '  '`
+              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | $TR '\n\r' '  '`
               { $as_echo "$as_me:${as_lineno-$LINENO}: result: $BOOT_JDK_VERSION" >&5
 $as_echo "$BOOT_JDK_VERSION" >&6; }
             fi # end check jdk version
@@ -24211,7 +24231,7 @@
             BOOT_JDK_FOUND=no
           else
             # Oh, this is looking good! We probably have found a proper JDK. Is it the correct version?
-            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | head -n 1`
+            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | head -n 1`
 
             # Extra M4 quote needed to protect [] in grep expression.
             FOUND_VERSION_78=`echo $BOOT_JDK_VERSION | grep  '\"1\.[78]\.'`
@@ -24363,7 +24383,7 @@
 $as_echo "$BOOT_JDK" >&6; }
               { $as_echo "$as_me:${as_lineno-$LINENO}: checking Boot JDK version" >&5
 $as_echo_n "checking Boot JDK version... " >&6; }
-              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | $TR '\n\r' '  '`
+              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | $TR '\n\r' '  '`
               { $as_echo "$as_me:${as_lineno-$LINENO}: result: $BOOT_JDK_VERSION" >&5
 $as_echo "$BOOT_JDK_VERSION" >&6; }
             fi # end check jdk version
@@ -24417,7 +24437,7 @@
             BOOT_JDK_FOUND=no
           else
             # Oh, this is looking good! We probably have found a proper JDK. Is it the correct version?
-            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | head -n 1`
+            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | head -n 1`
 
             # Extra M4 quote needed to protect [] in grep expression.
             FOUND_VERSION_78=`echo $BOOT_JDK_VERSION | grep  '\"1\.[78]\.'`
@@ -24569,7 +24589,7 @@
 $as_echo "$BOOT_JDK" >&6; }
               { $as_echo "$as_me:${as_lineno-$LINENO}: checking Boot JDK version" >&5
 $as_echo_n "checking Boot JDK version... " >&6; }
-              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | $TR '\n\r' '  '`
+              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | $TR '\n\r' '  '`
               { $as_echo "$as_me:${as_lineno-$LINENO}: result: $BOOT_JDK_VERSION" >&5
 $as_echo "$BOOT_JDK_VERSION" >&6; }
             fi # end check jdk version
@@ -24606,7 +24626,7 @@
             BOOT_JDK_FOUND=no
           else
             # Oh, this is looking good! We probably have found a proper JDK. Is it the correct version?
-            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | head -n 1`
+            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | head -n 1`
 
             # Extra M4 quote needed to protect [] in grep expression.
             FOUND_VERSION_78=`echo $BOOT_JDK_VERSION | grep  '\"1\.[78]\.'`
@@ -24758,7 +24778,7 @@
 $as_echo "$BOOT_JDK" >&6; }
               { $as_echo "$as_me:${as_lineno-$LINENO}: checking Boot JDK version" >&5
 $as_echo_n "checking Boot JDK version... " >&6; }
-              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | $TR '\n\r' '  '`
+              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | $TR '\n\r' '  '`
               { $as_echo "$as_me:${as_lineno-$LINENO}: result: $BOOT_JDK_VERSION" >&5
 $as_echo "$BOOT_JDK_VERSION" >&6; }
             fi # end check jdk version
@@ -24813,7 +24833,7 @@
             BOOT_JDK_FOUND=no
           else
             # Oh, this is looking good! We probably have found a proper JDK. Is it the correct version?
-            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | head -n 1`
+            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | head -n 1`
 
             # Extra M4 quote needed to protect [] in grep expression.
             FOUND_VERSION_78=`echo $BOOT_JDK_VERSION | grep  '\"1\.[78]\.'`
@@ -24965,7 +24985,7 @@
 $as_echo "$BOOT_JDK" >&6; }
               { $as_echo "$as_me:${as_lineno-$LINENO}: checking Boot JDK version" >&5
 $as_echo_n "checking Boot JDK version... " >&6; }
-              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | $TR '\n\r' '  '`
+              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | $TR '\n\r' '  '`
               { $as_echo "$as_me:${as_lineno-$LINENO}: result: $BOOT_JDK_VERSION" >&5
 $as_echo "$BOOT_JDK_VERSION" >&6; }
             fi # end check jdk version
@@ -25002,7 +25022,7 @@
             BOOT_JDK_FOUND=no
           else
             # Oh, this is looking good! We probably have found a proper JDK. Is it the correct version?
-            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | head -n 1`
+            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | head -n 1`
 
             # Extra M4 quote needed to protect [] in grep expression.
             FOUND_VERSION_78=`echo $BOOT_JDK_VERSION | grep  '\"1\.[78]\.'`
@@ -25154,7 +25174,7 @@
 $as_echo "$BOOT_JDK" >&6; }
               { $as_echo "$as_me:${as_lineno-$LINENO}: checking Boot JDK version" >&5
 $as_echo_n "checking Boot JDK version... " >&6; }
-              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | $TR '\n\r' '  '`
+              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | $TR '\n\r' '  '`
               { $as_echo "$as_me:${as_lineno-$LINENO}: result: $BOOT_JDK_VERSION" >&5
 $as_echo "$BOOT_JDK_VERSION" >&6; }
             fi # end check jdk version
@@ -25190,7 +25210,7 @@
             BOOT_JDK_FOUND=no
           else
             # Oh, this is looking good! We probably have found a proper JDK. Is it the correct version?
-            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | head -n 1`
+            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | head -n 1`
 
             # Extra M4 quote needed to protect [] in grep expression.
             FOUND_VERSION_78=`echo $BOOT_JDK_VERSION | grep  '\"1\.[78]\.'`
@@ -25342,7 +25362,7 @@
 $as_echo "$BOOT_JDK" >&6; }
               { $as_echo "$as_me:${as_lineno-$LINENO}: checking Boot JDK version" >&5
 $as_echo_n "checking Boot JDK version... " >&6; }
-              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | $TR '\n\r' '  '`
+              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | $TR '\n\r' '  '`
               { $as_echo "$as_me:${as_lineno-$LINENO}: result: $BOOT_JDK_VERSION" >&5
 $as_echo "$BOOT_JDK_VERSION" >&6; }
             fi # end check jdk version
Index: jdk/src/share/native/com/sun/java/util/jar/pack/jni.cpp
<+>UTF-8
===================================================================
diff --git a/jdk/src/share/native/com/sun/java/util/jar/pack/jni.cpp b/jdk/src/share/native/com/sun/java/util/jar/pack/jni.cpp
--- a/jdk/src/share/native/com/sun/java/util/jar/pack/jni.cpp	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/jdk/src/share/native/com/sun/java/util/jar/pack/jni.cpp	(date 1708602265888)
@@ -292,7 +292,7 @@
 
   if (uPtr->aborting()) {
     THROW_IOE(uPtr->get_abort_message());
-    return false;
+    return 0;
   }
 
   // We have fetched all the files.
Index: hotspot/make/bsd/makefiles/dtrace.make
<+>UTF-8
===================================================================
diff --git a/hotspot/make/bsd/makefiles/dtrace.make b/hotspot/make/bsd/makefiles/dtrace.make
--- a/hotspot/make/bsd/makefiles/dtrace.make	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/hotspot/make/bsd/makefiles/dtrace.make	(date 1708515316554)
@@ -68,11 +68,9 @@
 
 # Use mapfile with libjvm_db.so
 LIBJVM_DB_MAPFILE = # no mapfile for usdt2 # $(MAKEFILES_DIR)/mapfile-vers-jvm_db
-#LFLAGS_JVM_DB += $(MAPFLAG:FILENAME=$(LIBJVM_DB_MAPFILE))
 
 # Use mapfile with libjvm_dtrace.so
 LIBJVM_DTRACE_MAPFILE = # no mapfile for usdt2 # $(MAKEFILES_DIR)/mapfile-vers-jvm_dtrace
-#LFLAGS_JVM_DTRACE += $(MAPFLAG:FILENAME=$(LIBJVM_DTRACE_MAPFILE))
 
 LFLAGS_JVM_DB += $(PICFLAG) # -D_REENTRANT
 LFLAGS_JVM_DTRACE += $(PICFLAG) # -D_REENTRANT
@@ -260,10 +258,6 @@
   endif
 endif
 
-#$(DTRACE).d: $(DTRACE_SRCDIR)/hotspot.d $(DTRACE_SRCDIR)/hotspot_jni.d \
-#             $(DTRACE_SRCDIR)/hs_private.d $(DTRACE_SRCDIR)/jhelper.d
-#	$(QUIETLY) cat $^ > $@
-
 $(DtraceOutDir):
 	mkdir $(DtraceOutDir)
 
@@ -276,100 +270,24 @@
 $(DtraceOutDir)/hs_private.h: $(DTRACE_SRCDIR)/hs_private.d | $(DtraceOutDir)
 	$(QUIETLY) $(DTRACE_PROG) $(DTRACE_OPTS) -C -I. -h -o $@ -s $(DTRACE_SRCDIR)/hs_private.d
 
-$(DtraceOutDir)/jhelper.h: $(DTRACE_SRCDIR)/jhelper.d $(JVMOFFS).o | $(DtraceOutDir)
-	$(QUIETLY) $(DTRACE_PROG) $(DTRACE_OPTS) -C -I. -h -o $@ -s $(DTRACE_SRCDIR)/jhelper.d
-
-# jhelper currently disabled
-dtrace_gen_headers: $(DtraceOutDir)/hotspot.h $(DtraceOutDir)/hotspot_jni.h $(DtraceOutDir)/hs_private.h 
+dtrace_gen_headers: $(DtraceOutDir)/hotspot.h $(DtraceOutDir)/hotspot_jni.h $(DtraceOutDir)/hs_private.h
 
-DTraced_Files = ciEnv.o \
-                classLoadingService.o \
-                compileBroker.o \
-                hashtable.o \
-                instanceKlass.o \
-                java.o \
-                jni.o \
-                jvm.o \
-                memoryManager.o \
-                nmethod.o \
-                objectMonitor.o \
-                runtimeService.o \
-                sharedRuntime.o \
-                synchronizer.o \
-                thread.o \
-                unsafe.o \
-                vmThread.o \
-                vmCMSOperations.o \
-                vmPSOperations.o \
-                vmGCOperations.o \
-
-# Dtrace is available, so we build $(DTRACE.o)  
-#$(DTRACE.o): $(DTRACE).d $(JVMOFFS).h $(JVMOFFS)Index.h $(DTraced_Files)
-#	@echo Compiling $(DTRACE).d
-
-#	$(QUIETLY) $(DTRACE_PROG) $(DTRACE_OPTS) -C -I. -G -xlazyload -o $@ -s $(DTRACE).d \
-#     $(DTraced_Files) ||\
-#  STATUS=$$?;\
-#	if [ x"$$STATUS" = x"1" -a \
-#       x`uname -r` = x"5.10" -a \
-#       x`uname -p` = x"sparc" ]; then\
-#    echo "*****************************************************************";\
-#    echo "* If you are building server compiler, and the error message is ";\
-#    echo "* \"incorrect ELF machine type...\", you have run into solaris bug ";\
-#    echo "* 6213962, \"dtrace -G doesn't work on sparcv8+ object files\".";\
-#    echo "* Either patch/upgrade your system (>= S10u1_15), or set the ";\
-#    echo "* environment variable HOTSPOT_DISABLE_DTRACE_PROBES to disable ";\
-#    echo "* dtrace probes for this build.";\
-#    echo "*****************************************************************";\
-#  fi;\
-#  exit $$STATUS
-  # Since some DTraced_Files are in LIBJVM.o and they are touched by this
-  # command, and libgenerateJvmOffsets.so depends on LIBJVM.o, 'make' will
-  # think it needs to rebuild libgenerateJvmOffsets.so and thus JvmOffsets*
-  # files, but it doesn't, so we touch the necessary files to prevent later
-  # recompilation. Note: we only touch the necessary files if they already
-  # exist in order to close a race where an empty file can be created
-  # before the real build rule is executed.
-  # But, we can't touch the *.h files:  This rule depends
-  # on them, and that would cause an infinite cycle of rebuilding.
-  # Neither the *.h or *.ccp files need to be touched, since they have
-  # rules which do not update them when the generator file has not
-  # changed their contents.
-#	$(QUIETLY) if [ -f lib$(GENOFFS).so ]; then touch lib$(GENOFFS).so; fi
-#	$(QUIETLY) if [ -f $(GENOFFS) ]; then touch $(GENOFFS); fi
-#	$(QUIETLY) if [ -f $(JVMOFFS.o) ]; then touch $(JVMOFFS.o); fi
-
 .PHONY: dtraceCheck
 
-#SYSTEM_DTRACE_H = /usr/include/dtrace.h
 SYSTEM_DTRACE_PROG = /usr/sbin/dtrace
-#PATCH_DTRACE_PROG = /opt/SUNWdtrd/sbin/dtrace
 systemDtraceFound := $(wildcard ${SYSTEM_DTRACE_PROG})
-#patchDtraceFound := $(wildcard ${PATCH_DTRACE_PROG})
-#systemDtraceHdrFound := $(wildcard $(SYSTEM_DTRACE_H))
 
-#ifneq ("$(systemDtraceHdrFound)", "") 
-#CFLAGS += -DHAVE_DTRACE_H
-#endif
-
-#ifneq ("$(patchDtraceFound)", "")
-#DTRACE_PROG=$(PATCH_DTRACE_PROG)
-#DTRACE_INCL=-I/opt/SUNWdtrd/include
-#else
 ifneq ("$(systemDtraceFound)", "")
 DTRACE_PROG=$(SYSTEM_DTRACE_PROG)
 else
 
-endif # ifneq ("$(systemDtraceFound)", "")
-#endif # ifneq ("$(patchDtraceFound)", "")
+endif
 
 ifneq ("${DTRACE_PROG}", "")
 ifeq ("${HOTSPOT_DISABLE_DTRACE_PROBES}", "")
 
 DTRACE_OBJS = $(DTRACE.o) #$(JVMOFFS.o)
 CFLAGS += -DDTRACE_ENABLED #$(DTRACE_INCL)
-#clangCFLAGS += -DDTRACE_ENABLED -fno-optimize-sibling-calls
-#MAPFILE_DTRACE_OPT = $(MAPFILE_DTRACE)
 
 
 dtraceCheck:
Index: common/autoconf/boot-jdk.m4
<+>UTF-8
===================================================================
diff --git a/common/autoconf/boot-jdk.m4 b/common/autoconf/boot-jdk.m4
--- a/common/autoconf/boot-jdk.m4	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/common/autoconf/boot-jdk.m4	(date 1708510104492)
@@ -51,7 +51,7 @@
             BOOT_JDK_FOUND=no
           else
             # Oh, this is looking good! We probably have found a proper JDK. Is it the correct version?
-            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | head -n 1`
+            BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | head -n 1`
 
             # Extra M4 quote needed to protect [] in grep expression.
             [FOUND_VERSION_78=`echo $BOOT_JDK_VERSION | grep  '\"1\.[78]\.'`]
@@ -66,7 +66,7 @@
               AC_MSG_CHECKING([for Boot JDK])
               AC_MSG_RESULT([$BOOT_JDK])
               AC_MSG_CHECKING([Boot JDK version])
-              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | $TR '\n\r' '  '`
+              BOOT_JDK_VERSION=`"$BOOT_JDK/bin/java" -version 2>&1 | grep -v __NSAutoreleaseNoPool | $TR '\n\r' '  '`
               AC_MSG_RESULT([$BOOT_JDK_VERSION])
             fi # end check jdk version
           fi # end check rt.jar
Index: jdk/src/solaris/native/java/net/ExtendedOptionsImpl.c
<+>UTF-8
===================================================================
diff --git a/jdk/src/solaris/native/java/net/ExtendedOptionsImpl.c b/jdk/src/solaris/native/java/net/ExtendedOptionsImpl.c
--- a/jdk/src/solaris/native/java/net/ExtendedOptionsImpl.c	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/jdk/src/solaris/native/java/net/ExtendedOptionsImpl.c	(date 1708511317583)
@@ -348,6 +348,15 @@
 #define SOCK_OPT_LEVEL IPPROTO_TCP
 #define SOCK_OPT_NAME_KEEPIDLE TCP_KEEPALIVE
 #define SOCK_OPT_NAME_KEEPIDLE_STR "TCP_KEEPALIVE"
+
+#ifndef TCP_KEEPINTVL
+#define TCP_KEEPINTVL -1
+#endif
+
+#ifndef TCP_KEEPCNT
+#define TCP_KEEPCNT -1
+#endif
+
 #endif
 
 static jint socketOptionSupported(jint sockopt) {
Index: hotspot/src/share/vm/gc_implementation/shared/vmGCOperations.cpp
<+>UTF-8
===================================================================
diff --git a/hotspot/src/share/vm/gc_implementation/shared/vmGCOperations.cpp b/hotspot/src/share/vm/gc_implementation/shared/vmGCOperations.cpp
--- a/hotspot/src/share/vm/gc_implementation/shared/vmGCOperations.cpp	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/hotspot/src/share/vm/gc_implementation/shared/vmGCOperations.cpp	(date 1708515879173)
@@ -56,6 +56,7 @@
 #else /* USDT2 */
   HOTSPOT_GC_BEGIN(
                    full);
+  HS_DTRACE_WORKAROUND_TAIL_CALL_BUG();
 #endif /* USDT2 */
 }
 
@@ -64,8 +65,8 @@
   HS_DTRACE_PROBE(hotspot, gc__end);
   HS_DTRACE_WORKAROUND_TAIL_CALL_BUG();
 #else /* USDT2 */
-  HOTSPOT_GC_END(
-);
+  HOTSPOT_GC_END();
+  HS_DTRACE_WORKAROUND_TAIL_CALL_BUG();
 #endif /* USDT2 */
 }
 
Index: hotspot/src/share/vm/utilities/dtrace.hpp
<+>UTF-8
===================================================================
diff --git a/hotspot/src/share/vm/utilities/dtrace.hpp b/hotspot/src/share/vm/utilities/dtrace.hpp
--- a/hotspot/src/share/vm/utilities/dtrace.hpp	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/hotspot/src/share/vm/utilities/dtrace.hpp	(date 1708517062703)
@@ -38,7 +38,10 @@
 #define HS_DTRACE_WORKAROUND_TAIL_CALL_BUG() \
   do { volatile size_t dtrace_workaround_tail_call_bug = 1; } while (0)
 
-#define USDT1 1
+#define USDT2 1
+#include "dtracefiles/hotspot.h"
+#include "dtracefiles/hotspot_jni.h"
+#include "dtracefiles/hs_private.h"
 #elif defined(LINUX)
 #define HS_DTRACE_WORKAROUND_TAIL_CALL_BUG()
 #define USDT1 1
Index: hotspot/src/share/vm/runtime/java.cpp
<+>UTF-8
===================================================================
diff --git a/hotspot/src/share/vm/runtime/java.cpp b/hotspot/src/share/vm/runtime/java.cpp
--- a/hotspot/src/share/vm/runtime/java.cpp	(revision d4b472ff937883b62f26a39c9ddf72f07f9dfff8)
+++ b/hotspot/src/share/vm/runtime/java.cpp	(date 1708517032553)
@@ -60,6 +60,7 @@
 #include "runtime/thread.inline.hpp"
 #include "runtime/timer.hpp"
 #include "runtime/vm_operations.hpp"
+#include "runtime/vmThread.hpp"
 #include "services/memTracker.hpp"
 #include "utilities/dtrace.hpp"
 #include "utilities/globalDefinitions.hpp"
@@ -602,6 +603,7 @@
   HS_DTRACE_WORKAROUND_TAIL_CALL_BUG();
 #else /* USDT2 */
   HOTSPOT_VM_SHUTDOWN();
+  HS_DTRACE_WORKAROUND_TAIL_CALL_BUG();
 #endif /* USDT2 */
 }
 

