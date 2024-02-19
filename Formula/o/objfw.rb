class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.0.9.tar.gz"
  sha256 "2706af1dd584099495c68465843c4d49e613fecc57a39b565a7262ec5fae9474"
  license any_of: ["QPL-1.0", "GPL-2.0-only", "GPL-3.0-only"]
  head "https://objfw.nil.im/", using: :fossil

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "950628d09ff3d6d9650a02bbc18447e650c1b741f46812d0c9e5d307afb71a4e"
    sha256 arm64_ventura:  "e1a55836350b631b1da6e433fc7956a0c7aee58e543226996ddd9ea08d4a8b08"
    sha256 arm64_monterey: "b1bd277791e48a1dd4030857bc3c7d7c78f6ba516ceea018a3b078a67f34b732"
    sha256 sonoma:         "a6739f1554898fd1eeacf0a84d864394d5d10b90bc5027c3d4d978014f5c4ec0"
    sha256 ventura:        "2519c527cac50e88d50d712c573d9da6fcdf892d164893f2f47800a4421505a2"
    sha256 monterey:       "2590182771de9f1a8085a9e5815e762be22350a698ba3ca6f2dc0c94fdf85560"
    sha256 x86_64_linux:   "a2a81e6bcd779f2a7db023c495ba8118ef5d8b9ba5aa4b3e02142a0cebfde33e"
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

