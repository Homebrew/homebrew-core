class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.4.4.tar.gz"
  sha256 "29be5ea5d6a9c34b9873a40091367eb0b75072d627e2508380c02c38cb60ca38"
  license "LGPL-3.0-only"
  head "https://git.nil.im/ObjFW/ObjFW.git", branch: "main"

  livecheck do
    url "https://git.nil.im/ObjFW/ObjFW/releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "48f224124e67190e5e1c909ad41ae81ac9cbb55a21a4d96812528f73e72a5352"
    sha256 arm64_sequoia: "0127762013d41a99644f45fd5e884ed6e0cae1defb9005c2d121b5448f1afdec"
    sha256 arm64_sonoma:  "09c89cdbd46941bbbdf9b4e22a13d30c3f8c62a0da20d2cd2adf8f87535a42de"
    sha256 sonoma:        "fd8e544f9c42f56edf89b6be2634b96332dd7c057d594a896e592a8dbf933242"
    sha256 arm64_linux:   "9e1c182fb4c30f658c1dcfb0e124d60cfcd9091c99efa84fd97312018408a1cb"
    sha256 x86_64_linux:  "0490b4997febc80efa4d6491671a83bd48ed6c9fb3ea4c56031ad784992c2c60"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_linux do
    depends_on "llvm"
    depends_on "openssl@3"
    depends_on "zlib"
  end

  fails_with :gcc

  patch :DATA

  def install
    ENV.clang if OS.linux?

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    return unless OS.mac?

    inreplace bin/"objfw-config", 'OBJC="clang"', 'OBJC="/usr/bin/clang"'
  end

  test do
    system bin/"objfw-new", "--app", "Test"
    system bin/"objfw-compile", "-o", "t", "Test.m"
    system "./t"
  end
end

__END__
diff --git a/build-aux/m4/buildsys.m4 b/build-aux/m4/buildsys.m4
index 3ec1cc5c..c0c31cac 100644
--- a/build-aux/m4/buildsys.m4
+++ b/build-aux/m4/buildsys.m4
@@ -323,7 +323,7 @@ AC_DEFUN([BUILDSYS_FRAMEWORK], [
 		AS_IF([test x"$host_is_ios" = x"yes"], [
 			FRAMEWORK_LDFLAGS_INSTALL_NAME='-Wl,-install_name,@executable_path/Frameworks/$$out/$${out%.framework}'
 		], [
-			FRAMEWORK_LDFLAGS_INSTALL_NAME='-Wl,-install_name,@executable_path/../Frameworks/$$out/$${out%.framework}'
+			FRAMEWORK_LDFLAGS_INSTALL_NAME='-Wl,-install_name,@loader_path/../../../$$out/$${out%.framework}'
 		])
 
 		AC_SUBST(FRAMEWORK_LDFLAGS)

