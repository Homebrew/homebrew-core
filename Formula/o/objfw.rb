class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.5.1.tar.gz"
  sha256 "fde83565ad1c6aaea2713770ede8f47f1b1e464c9251dde4801e1c614930cdf6"
  license "LGPL-3.0-only"
  head "https://git.nil.im/ObjFW/ObjFW.git", branch: "main"

  livecheck do
    url "https://git.nil.im/ObjFW/ObjFW/releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "4aca22fe35b66db1f2c0b8808520780e46b6a17cf9238262f4c7d8c2aba55396"
    sha256 arm64_sequoia: "8d6a02fb7c647068536cdcc7ac56ee53b945e9e0ae1ac1f01002ec75edfcb7d7"
    sha256 arm64_sonoma:  "10bbac85b100f0fe4f24ff5ec41cb7c339418a131269a3ce7896f5c3dc3a6b04"
    sha256 sonoma:        "38797298bcdd01e52e7926cdf6523c49ab24ff36eefc72f3523be211ac32ae2a"
    sha256 arm64_linux:   "132fde952366c5234483410e288bcc77b99c2d1fdf0e35e679372f4fe1e39004"
    sha256 x86_64_linux:  "a68440b6b1f6e5b9aea52a4beb2a5a732e6e9c33c4a7035d4a2d4f26d7b9ad6e"
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
