class Io < Formula
  desc "Small prototype-based programming language"
  homepage "http://iolanguage.com/"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/IoLanguage/io.git", branch: "master"

  stable do
    url "https://github.com/IoLanguage/io/archive/refs/tags/2017.09.06.tar.gz"
    sha256 "9ac5cd94bbca65c989cd254be58a3a716f4e4f16480f0dc81070457aa353c217"

    # Backport commits to build on arm64
    on_macos do
      on_arm do
        # Backport CMake changes to cleanly apply later commits
        patch do
          url "https://github.com/IoLanguage/io/commit/27d3900e8a88d0ee45773666a5a257ca735eb0b0.patch?full_index=1"
          sha256 "937ba88cecf017b19791b13e8f721060b91af319ba753463b40353a56d6fa99d"
        end
        patch do
          url "https://github.com/IoLanguage/io/commit/27e87f614992df745d894b5190c95180baf9cf4b.patch?full_index=1"
          sha256 "142761908bc1cb2e04c442e1d97397f39b063d64d10079750b396316280ccf7e"
        end
        patch do
          url "https://github.com/IoLanguage/io/commit/72c8a7ec1e0711ba54754b17def08e3fdcea4f66.patch?full_index=1"
          sha256 "634ded26ac1e1015ec1ece869c7311ec1db7639b6c6bfb976f74c7617c7b417f"
        end
        patch do
          url "https://github.com/IoLanguage/io/commit/b200c7f0e0f899a19d576852e931badb542f37a7.patch?full_index=1"
          sha256 "85f942c3b25238ab722d26944ff2c11d8e55cd6c3d4373e8121c2a31d1fe1fd5"
        end

        # Backport some clang-format whitespace changes from
        # https://github.com/IoLanguage/io/commit/158ee62d2551ceffcc1a34616baa38794e59e21f
        patch :DATA

        # Backport support for arm64
        patch do
          url "https://github.com/IoLanguage/io/commit/bb5fa48fc272e0e8febda40c0f9f6c85cd788a60.patch?full_index=1"
          sha256 "b6f1100606dc2539abdd0707fe6a578cd7e462db7f70d192a9613860e67bf760"
        end
      end
    end

    # Backport fix for Linux build
    patch do
      url "https://github.com/IoLanguage/io/commit/92fe8304c55b84a17b0624613a7006e85a0128a2.patch?full_index=1"
      sha256 "183367979123123671fcd076aba3820ed20066add66725211a396eb5c621a6c6"
    end

    # build patch for sysctl.h as glibc 2.32 removed <sys/sysctl.h>
    patch do
      url "https://github.com/IoLanguage/io/commit/9f3e4d87b6d4c1bf583134d55d1cf92d3464c49f.patch?full_index=1"
      sha256 "2ee70f5e61d1b798bea172fb357381c7781eecd465714de7ad56c56fd89f5c1c"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "f52b3f34e2163977455f08819a17df42ebec1148781c3df76411e3743e251d5c"
    sha256 arm64_sequoia: "9cd4d01893fe007c243216871642b659664f5273c0bfa3e6ed52b253e2aa80e7"
    sha256 arm64_sonoma:  "ee036449cf0d3a7752967588f5acf9ad8057821346fa836f372b04a46a88f385"
    sha256 sonoma:        "9ceacf2ba834c91d5101adb7061bfd7c1ae702d9fbbbd9d8f78b5e82d049fd7e"
    sha256 ventura:       "914d9b485bd7ceaec9bc8e43c9ffff86560ced0074ea2ae73312c45fafc0e01e"
    sha256 monterey:      "2bbd166e8e51dd46f71818b6d2acad483af7cd19c2f8f114e5e713a64740d438"
    sha256 arm64_linux:   "7fb2cd769bab17e5a6e13563e09fb02bbd1da5e25d4fe541335b97f9f22fbc04"
    sha256 x86_64_linux:  "28f27659192940b8773ab23b0d237befa1ebb90ca6b771f82852422631f6549e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  def install
    ENV.deparallelize

    # FSF GCC needs this to build the ObjC bridge
    ENV.append_to_cflags "-fobjc-exceptions"

    if build.stable?
      inreplace "CMakeLists.txt" do |s|
        # Turn off all add-ons in main cmake file
        s.gsub! "add_subdirectory(addons)", "#add_subdirectory(addons)"
        # Allow building on non-x86_64 platforms
        # Ref: https://github.com/IoLanguage/io/issues/450 / https://github.com/IoLanguage/io/issues/474
        s.gsub! 'SET(CMAKE_C_FLAGS "-msse2")', "" if OS.linux? && !Hardware::CPU.intel?
      end
    end

    args = %W[
      -DCMAKE_DISABLE_FIND_PACKAGE_ODE=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_Theora=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.io").write <<~IO
      "it works!" println
    IO

    assert_equal "it works!\n", shell_output("#{bin}/io test.io")
  end
end

__END__
diff --git a/libs/coroutine/source/Coro.c b/libs/coroutine/source/Coro.c
index 88951158..25219b47 100644
--- a/libs/coroutine/source/Coro.c
+++ b/libs/coroutine/source/Coro.c
@@ -70,9 +70,7 @@ typedef struct CallbackBlock
 #endif
 } CallbackBlock;
 
-
-Coro *Coro_new(void)
-{
+Coro *Coro_new(void) {
 	Coro *self = (Coro *)io_calloc(1, sizeof(Coro));
 	self->requestedStackSize = CORO_DEFAULT_STACK_SIZE;
 	self->allocatedStackSize = 0;
diff --git a/libs/coroutine/source/taskimpl.h b/libs/coroutine/source/taskimpl.h
index e3742315..8b871b29 100644
--- a/libs/coroutine/source/taskimpl.h
+++ b/libs/coroutine/source/taskimpl.h
@@ -106,17 +106,17 @@ extern	void		makecontext(ucontext_t*, void(*)(), int, ...);
 #endif
 
 #if defined(__APPLE__)
-#	define mcontext libthread_mcontext
-#	define mcontext_t libthread_mcontext_t
-#	define ucontext libthread_ucontext
-#	define ucontext_t libthread_ucontext_t
-#	if defined(__i386__)
-#		include "386-ucontext.h"
-#	elif defined(__x86_64__)
-#		include "amd64-ucontext.h"
-#	else
-#		include "power-ucontext.h"
-#	endif
+#define mcontext libthread_mcontext
+#define mcontext_t libthread_mcontext_t
+#define ucontext libthread_ucontext
+#define ucontext_t libthread_ucontext_t
+#if defined(__i386__)
+#include "386-ucontext.h"
+#elif defined(__x86_64__)
+#include "amd64-ucontext.h"
+#else
+#include "power-ucontext.h"
+#endif
 #endif
 
 #if defined(__OpenBSD__)
