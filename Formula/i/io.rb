class Io < Formula
  desc "Small prototype-based programming language"
  homepage "http://iolanguage.com/"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/IoLanguage/io.git", branch: "master"

  stable do
    url "https://github.com/IoLanguage/io/archive/refs/tags/2017.09.06.tar.gz"
    sha256 "9ac5cd94bbca65c989cd254be58a3a716f4e4f16480f0dc81070457aa353c217"

    # Backport fix for Linux build
    patch do
      url "https://github.com/IoLanguage/io/commit/92fe8304c55b84a17b0624613a7006e85a0128a2.patch?full_index=1"
      sha256 "183367979123123671fcd076aba3820ed20066add66725211a396eb5c621a6c6"
    end

    # build patch for sysctl.h as glibc 2.32 removed <sys/sysctl.h>
    patch :DATA
  end

  bottle do
    rebuild 1
    sha256 sonoma:       "9ceacf2ba834c91d5101adb7061bfd7c1ae702d9fbbbd9d8f78b5e82d049fd7e"
    sha256 ventura:      "914d9b485bd7ceaec9bc8e43c9ffff86560ced0074ea2ae73312c45fafc0e01e"
    sha256 monterey:     "2bbd166e8e51dd46f71818b6d2acad483af7cd19c2f8f114e5e713a64740d438"
    sha256 arm64_linux:  "7fb2cd769bab17e5a6e13563e09fb02bbd1da5e25d4fe541335b97f9f22fbc04"
    sha256 x86_64_linux: "28f27659192940b8773ab23b0d237befa1ebb90ca6b771f82852422631f6549e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "libxml2"

  on_macos do
    depends_on arch: :x86_64 # https://github.com/IoLanguage/io/issues/465
  end

  def install
    ENV.deparallelize

    # FSF GCC needs this to build the ObjC bridge
    ENV.append_to_cflags "-fobjc-exceptions"

    inreplace "CMakeLists.txt" do |s|
      # Turn off all add-ons in main cmake file
      s.gsub! "add_subdirectory(addons)", "#add_subdirectory(addons)" unless build.head?
      # Allow building on non-x86_64 platforms
      # Ref: https://github.com/IoLanguage/io/issues/450 / https://github.com/IoLanguage/io/issues/474
      s.gsub! 'SET(CMAKE_C_FLAGS "-msse2")', "" unless Hardware::CPU.intel?
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
    (testpath/"test.io").write <<~EOS
      "it works!" println
    EOS

    assert_equal "it works!\n", shell_output("#{bin}/io test.io")
  end
end

__END__
diff --git a/libs/iovm/source/IoSystem.c b/libs/iovm/source/IoSystem.c
index a6234f7..af3a975 100755
--- a/libs/iovm/source/IoSystem.c
+++ b/libs/iovm/source/IoSystem.c
@@ -22,7 +22,7 @@ Contains methods related to the IoVM.
 #if defined(__NetBSD__) || defined(__OpenBSD__)
 # include <sys/param.h>
 #endif
-#ifndef __CYGWIN__
+#if defined(HAVE_SYS_SYSCTL_H) && !defined(__GLIBC__)
 # include <sys/sysctl.h>
 #endif
 #endif
