class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.0.11.tar.gz"
  sha256 "21a85cd75a508fecf77a61c12932c2b4e33c06c51f8d618743cb162a87b9af14"
  license any_of: ["QPL-1.0", "GPL-2.0-only", "GPL-3.0-only"]
  head "https://objfw.nil.im/", using: :fossil

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "72f9126a5f8f7e296fe01e452fe29e79c6088c4c98c52a0fad3b1bea93d56c57"
    sha256 arm64_ventura:  "f82b6d751c6ddd8a16eef0ed25b0562f6153313c70f7d119f834b80db5b45fe3"
    sha256 arm64_monterey: "9f328e4283b6bf0edaca8598abaef248ef85fd3b5b76c9d37d7a3e693d2fbd5b"
    sha256 sonoma:         "554ec5e972ba9b136a289f7b1cb8bad74714465fdf430143fa21eb736000fb4f"
    sha256 ventura:        "bc42dc4625060b10dfd630a4af8b7e121f74940601432a8732b4faeff851fa45"
    sha256 monterey:       "202b34cab76f76a62ee772c37c48a33083ad1f60cdee4d8f2c19bb0084c1b2e3"
    sha256 x86_64_linux:   "f957bfd7b433ee125ed53eb40a725f9f8b3dc67457036176c03781c3ddb0f0ba"
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

