class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.1.6.tar.gz"
  sha256 "c19a97a011e14780fb32cfbdbbd6a699a955b57124e4e079768cb8aad4430e1d"
  license "LGPL-3.0-only"
  head "https://objfw.nil.im/", using: :fossil

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "2541b35c745798c93c378915591e7a951f0e352f3bc7bb1eb62588878fc0ad8d"
    sha256 arm64_ventura:  "0fe29b83fe3106c4b67e3471185b795c1b9ffb47940cd78fc27a3d8be4678eba"
    sha256 arm64_monterey: "67f38ba520cd40b4b728f6530e4059181cd0c6a9ef1223081597524aebbac325"
    sha256 sonoma:         "9386d46b51e5d70f39faf3277eae589ab0cddacd836c7e6c19f48ac9118a4853"
    sha256 ventura:        "2d0348fd5828307e9892704e7b4c8eea81a2f4a825d89bcbf7b3af2ff476c416"
    sha256 monterey:       "1446829e9e03d4ac4f8bf1d96bebd2c6033ca5a73ca7f08c366d42c016629465"
    sha256 x86_64_linux:   "5bbb8156b66c80b6bf2400d75acb237da515a832e81eda131f8068ffbbd25aa6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_linux do
    depends_on "llvm"
    depends_on "openssl@3"
  end

  fails_with :gcc

  patch :DATA

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    inreplace bin/"objfw-config", "llvm_clang", "clang" if OS.linux?
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
+			FRAMEWORK_LDFLAGS_INSTALL_NAME='-Wl,-install_name,${prefix}/Library/Frameworks/$$out/$${out%.framework}'
 		])
 
 		AC_SUBST(FRAMEWORK_LDFLAGS)

