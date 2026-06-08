class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.5.5.tar.gz"
  sha256 "d36c95f545b83879038630416da82a923b7a7d8ef155d348cda0ff56d021a2d3"
  license "LGPL-3.0-only"
  head "https://git.nil.im/ObjFW/ObjFW.git", branch: "main"

  livecheck do
    url "https://git.nil.im/ObjFW/ObjFW/releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "51a8a85b27d9a7b44837108dcd38614b70e5607d7a99b835b2b3ae9fa61406c0"
    sha256 arm64_sequoia: "cb1dbb47bbb3cab11da7aa24f356f07d0f761a983134d45f5d06b525997fd261"
    sha256 arm64_sonoma:  "d5affae89299afe69756caa2edf520b85dca488e69ae2cddb6b962dc78b411eb"
    sha256 sonoma:        "7c5c0f0ab8aaea8391285b9b980ae9006f2093e120a42a1f4791e10e271dc1fe"
    sha256 arm64_linux:   "642937bb33e49dae223290230b1080fb6be53884aadadfd479828d4e1a2ee080"
    sha256 x86_64_linux:  "69cea97c87f11a512b38cf618f5641315d1cb8a7d685f7fff5d842dbfdce8ca6"
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
