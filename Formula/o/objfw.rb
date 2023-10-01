class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.0.3.tar.gz"
  sha256 "1c81d7d03578b2d9084fc5d8722d4eaa4bdc2f3f09ce41231e7ceab8212fae17"
  license any_of: ["QPL-1.0", "GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url "https://objfw.nil.im/wiki?name=Releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "09c7d3773da3a6f22f5039331669f6651955cbe7aeaac70bef485d53686ab296"
    sha256 arm64_monterey: "a7d37a06a2f3655634641f063a57ebbef377840080c9680ff9aa78195ca25912"
    sha256 arm64_big_sur:  "ea2bfcb07b53fd68110187c7d0223c03656703245263cf652080532a43c18de2"
    sha256 ventura:        "d68f363f022f6687cdcaf302f193b710908265841a59fbcbaf1b03e4a5ca24c9"
    sha256 monterey:       "d5477967a8ee629aca8fffc52d68e887f38454f7e2bb44a52ec04a1119e085ae"
    sha256 big_sur:        "da289589275ea7828d4dde5e3ca909aa5a8d0030327186f4325b28bd30289e57"
    sha256 x86_64_linux:   "7d42f608d3c923914b0b7d6fc1a118cca0068852d6522a50fbbb492169990b64"
  end

  head do
    url "https://github.com/ObjFW/ObjFW.git", branch: "master"
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

