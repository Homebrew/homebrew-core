class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.0.4.tar.gz"
  sha256 "c62c61fc3f1b2d5c1d78369c602a6e82b32ade5c8ec0e9c410646d1554bf1e26"
  license any_of: ["QPL-1.0", "GPL-2.0-only", "GPL-3.0-only"]
  head "https://objfw.nil.im/", using: :fossil

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "0346f45b9afda9ff39f9a62b9c69630e640f63d829b01b3d1895758ff82fe3d7"
    sha256 arm64_ventura:  "0fe421b097253bbcad02b2048bfaaab81fa4c431b470339922de4ec7aca36dfd"
    sha256 arm64_monterey: "ad5c57e7f23951870014747e682f905355dc3b71d3a120159007bc00a5dbf71c"
    sha256 sonoma:         "674112979219a5b9c3e667e3f305b695ac64e5787d4a9892f2d1f79a875a7ba9"
    sha256 ventura:        "23ba43d00bc7bda76c68506a6d15c92b10ef6e80b0a34999cbf9f7133696f22a"
    sha256 monterey:       "91e352998f798eccb434dcf81e659d184ab664803579500a010e81b27db3d5ab"
    sha256 x86_64_linux:   "c5d44b5c218ff3aaefc581a4a5d00f7e302ec38d28dde305847ae28c0d11271c"
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

