class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.5.7.tar.gz"
  sha256 "e637c32731dc07396b812c4019f34d1417a3f7aa39d450b7f27c9bcdc23b3e12"
  license "LGPL-3.0-only"
  head "https://git.nil.im/ObjFW/ObjFW.git", branch: "main"

  livecheck do
    url "https://git.nil.im/ObjFW/ObjFW/releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d26124e8f5b8ed93dee88c5701bbcfb2c2899352115bcfc062587eae738f8a07"
    sha256 arm64_sequoia: "f4d373bd9d4e274baf4b663d3d774042e62e919d18c5a61394c6e99f346a86ea"
    sha256 arm64_sonoma:  "b5c85d7a7a69ffa812c49319e4dbe7a92071ae494cbefad0bdf08b83abb49a9e"
    sha256 sonoma:        "c7be82ff8bd5d4f7fdb65a55ccd2ab97bded01cb1d777455991227807a4c6bd4"
    sha256 arm64_linux:   "e207568c4a5d27b20232df54b6e78f076c30f9e3bbfb73d06b7844381f4851b9"
    sha256 x86_64_linux:  "e5f54a7a545408a3ecfc109ee65e4a037f4d21ffdacfa4ad4fd2a3cc42000cc2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "llvm"
    depends_on "zlib-ng-compat"
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
