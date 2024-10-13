class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.1.7.tar.gz"
  sha256 "5107d8a0627e2270d211abf1b4f6c50fd89c8d672d2179b50daa7d3b66d68a70"
  license "LGPL-3.0-only"
  head "https://objfw.nil.im/", using: :fossil

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "9de39fb90e098e9756b64aa558325ba11b6c51f4a22c80a3cf97b72635e15e4c"
    sha256 arm64_sonoma:   "2429582a6626f85edd6bfe3d3c698735a432456e0e7fc2631d79a44635862a36"
    sha256 arm64_ventura:  "6645218d4d7b56003e053ce67c2d0ce844faf6d575f8b406ff5c426f6cbf1715"
    sha256 arm64_monterey: "c670b6369e866ce49a54d5a09ebcc7552a3c98b6d46ca5416201d699851359ba"
    sha256 sonoma:         "1bf9a5a758adc3325325ac8c373adbd96e4cf1b0a96be61c16c41e837fda675d"
    sha256 ventura:        "a2b317e20e223746d43f72caac42483f4f0a862d5f87ddd3e4799dfcf630f19c"
    sha256 monterey:       "efa792a0c0e55e170f6a6e5bd50141a818e6446dc984cb1f7ec178922e2b4590"
    sha256 x86_64_linux:   "2e10b17a804df5c65d77018696953951bfe7e9e880f941730219bd3c09a9b911"
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

