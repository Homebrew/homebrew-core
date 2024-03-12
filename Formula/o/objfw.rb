class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.0.12.tar.gz"
  sha256 "d5f9d5dcb95c52f7b243b1b818a34be99cecaaa5afd6de1c5b2502214f5df7f7"
  license any_of: ["QPL-1.0", "GPL-2.0-only", "GPL-3.0-only"]
  head "https://objfw.nil.im/", using: :fossil

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "e70cffea23fb6bc77aa4c55af0eef2d5aa91a8424b4393c040b80e29383b7dfd"
    sha256 arm64_ventura:  "2b4f8f33e40c2c799d4afc503eb161a4c3631291c7a47aa329ed56a3a66e7267"
    sha256 arm64_monterey: "d74f83a2a66e0a6fc1d3f18723abc2807cfb56bbf7e54694fd98d514e01a2189"
    sha256 sonoma:         "e517e1e66d557a0ec4660410500422600b1ed6e0c0f944863e8ad0f39a8737d1"
    sha256 ventura:        "93870b4fc0e9e7409d97c0874f25dfc6ff749d9676960bfed7cb5c7590600af3"
    sha256 monterey:       "2c2df48517f2518a3b1cbcfc9c47173655fcfe9c383e3047179a202a52332828"
    sha256 x86_64_linux:   "6200fc58c20a8db911e4fe9a1ce90db08acdf0c85b145568cba8c248e30b0267"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_linux do
    depends_on "llvm"
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
    system "#{bin}/objfw-new", "--app", "Test"
    system "#{bin}/objfw-compile", "-o", "t", "Test.m"
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

