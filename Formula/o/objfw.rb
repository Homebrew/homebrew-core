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
    rebuild 1
    sha256 arm64_golden_gate: "582e436d5ca560d556602a93cdf250a14aeff4b367c2619c4dee381ee2d6bbbb"
    sha256 arm64_tahoe:       "10b176023682f5111607d0e3c9f7bb0fbf6d7b662835ba0747abd53e4c1afda0"
    sha256 arm64_sequoia:     "06bed702a19c019baead09d2b29b9a7049d00cb6907239c3f2ba3d158b1d63b2"
    sha256 arm64_linux:       "73803cebaac8ffee2c5d65206dba8a1cae5c450f62e48dcf73ab2d240c787ba7"
    sha256 x86_64_linux:      "52d1fd8eace8f3ea3b0654ad97084ab04e3774885160509a92718ded789752fa"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl@4"

  uses_from_macos "llvm" => :no_linkage

  fails_with :gcc

  patch :DATA

  deny_network_access!

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
