class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.1.4.tar.gz"
  sha256 "f6bfdbab22008aae3e4b48d77ced1a04c5153961c6f7e5492891f90ae5131a78"
  license "LGPL-3.0-only"
  head "https://objfw.nil.im/", using: :fossil

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "a2dc723a2eacaac871a3ad0a5f5e269ed5f81ee445e8bc695bb6a5fd7a27fe24"
    sha256 arm64_ventura:  "a1fb8c5aa4ea05d4634b6c6c93cd6562a76986279778ddcfbbf30ccb809b5504"
    sha256 arm64_monterey: "5bf7bd399575bf6025f6ac329cfcdb7158f0cd7996351b446f2daf282ab7a4fd"
    sha256 sonoma:         "3e57a83458b08e27f4d18d119538fbbc141a92e3ca31f1832ddc698ad6b3fbbd"
    sha256 ventura:        "5afac3deee3c8288a74991356d2b492d1b84e5b318a4f2f0fb66c4717c0a7b63"
    sha256 monterey:       "6011644b70cb604bd183c1aa9dc3b22882a5e4a60476e014b3d700d89483b6d4"
    sha256 x86_64_linux:   "aee7a907f9d16cc6bb633e5eec513f00b150f2037329c8a0227ae23b834c6994"
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

