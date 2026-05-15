class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.5.2.tar.gz"
  sha256 "23c41c2ce6f2491d056c8e63cc4de6de8fcb1807825710eb1be92464b97173f8"
  license "LGPL-3.0-only"
  head "https://git.nil.im/ObjFW/ObjFW.git", branch: "main"

  livecheck do
    url "https://git.nil.im/ObjFW/ObjFW/releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "5deb548ddbcad3d8c8f7a580ca64f1014d100411bccbc898b5d1050c7f41d026"
    sha256 arm64_sequoia: "b366dc7085524e0c4308143118e661c948f40a46c667ae19554876d52ed77134"
    sha256 arm64_sonoma:  "9c114adb1716b54c88b939058f3eb1188c8807411c68d275fc9b04fc80064a47"
    sha256 sonoma:        "8bb244a90bf8fb0bb319edcb6315c5ef62d887d26463c7ecbd3ec400c0683be4"
    sha256 arm64_linux:   "e0cf127f0bb220f2eb4ff9fc4a54f904ce6ed254022ba9edfad9ded153e2b282"
    sha256 x86_64_linux:  "9960517ed99eadafe21d72de6dd4251764fc920081fec9b43ea24e73a3cbd838"
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
