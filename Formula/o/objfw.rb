class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.1.2.tar.gz"
  sha256 "5d9f9a70d583298e780ae11fc75a7ae2beeef904b301e1bc4f4ffa8d7ee31d9f"
  license "LGPL-3.0-only"
  head "https://objfw.nil.im/", using: :fossil

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "a05900c1409fe432e5db5795b407b45d3185abb26d22bf6b73ee9f5cfb7fdd29"
    sha256 arm64_ventura:  "4c36aeb22d5e221ded718e6fef79b6872960a62a35350dff96ef8c8109eaf33b"
    sha256 arm64_monterey: "db4dda312e2b8d7fbcbb5a56d5c11297aa99858495c6586d63044b4a9e8d0d35"
    sha256 sonoma:         "f9c5f1fce52c392a924adf1244dc511e677f881bed8d8c103aa4d1185eec2261"
    sha256 ventura:        "9f3f4b73fd5c27b39ad6b20004d29cedcfff844d17784fb539dd4a8ee59fb238"
    sha256 monterey:       "7cad8dfcb7adc908e56e581169d356a14d12f5ec57dcb829a41923736bc5fc86"
    sha256 x86_64_linux:   "fea630c33317a2e33f6736621dfac026b0cd63cbdab5e0cfb5c693c9fad89e10"
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

