class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.3.tar.gz"
  sha256 "de9e8a84437c01dacb9e83d7de0e3f7add3152165707d51a4caec640e4f56ba6"
  license "LGPL-3.0-only"
  head "https://objfw.nil.im/", using: :fossil

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
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

