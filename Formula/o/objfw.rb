class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.1.1.tar.gz"
  sha256 "0492a08f964180b7453c05bd9f0080e70b61171a9b5194a6d1b891370c24cfc0"
  license "LGPL-3.0-only"
  head "https://objfw.nil.im/", using: :fossil

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "44b31911df617c74da47c3b7e71bf8effec45e790f01c5d1de6fd857bac19eef"
    sha256 arm64_ventura:  "0e4bd1875199e97ede8926e72ff99a5887a91518b54db72cfdf2cea5ba54c04d"
    sha256 arm64_monterey: "cccc2dc83a942f7da4e029bbc3553364773c87ab6a5b8fa816ababf5458fe953"
    sha256 sonoma:         "f463b51183a8bfcc84d113d7b014bdd6958b382256b83d9acef29a83dad4e2f9"
    sha256 ventura:        "2d85b9acf66baf8d2d06dba5fe8062ed0b2f7c4287efaf007b8720fe9ac01321"
    sha256 monterey:       "79044a1110cd767ad788a0ae5199c2b7c609d052ae5a812a12fa235a32f5c727"
    sha256 x86_64_linux:   "3e2a44a615e9a019de88f7ff70b489764dd059796817eff5582fd59beb8112cd"
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

