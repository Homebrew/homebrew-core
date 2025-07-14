class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.3.2.tar.gz"
  sha256 "8148df0d55d1a3218fe9965144b5c3ee2a7f4d8e43e430a6107e294043872cab"
  license "LGPL-3.0-only"
  head "https://git.nil.im/ObjFW/ObjFW.git", branch: "main"

  livecheck do
    url "https://git.nil.im/ObjFW/ObjFW/releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "beae7540863a1bd426dc471cf9c2673344008fd266edd41b9a103ab7e10b6141"
    sha256 arm64_sonoma:  "43829254ef245340617d632f201caac594c76b81c0ec1907c554d0e0509a86db"
    sha256 arm64_ventura: "321bd53c3b72dc7783866636035f70c7243a900fdca2094739c03a0fc9df7cfd"
    sha256 sonoma:        "daf32fc7c8401967220ae43d63702c8bad70da6df970c3cd25c306aed93d8a7a"
    sha256 ventura:       "78a1f38e646712a0368a178c537b6842f38512a1dd68341fd7a56020f73f74e9"
    sha256 arm64_linux:   "ee605e9810975310d29f96a2b3652d056d3f5959e09551acb0c6547b71242e9e"
    sha256 x86_64_linux:  "3006257b454f839712b9b53634178d3b60926962e4db04acc54719fa724f7e29"
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
+			FRAMEWORK_LDFLAGS_INSTALL_NAME='-Wl,-install_name,${prefix}/Library/Frameworks/$$out/$${out%.framework}'
 		])
 
 		AC_SUBST(FRAMEWORK_LDFLAGS)

