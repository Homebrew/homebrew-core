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

  bottle do
    sha256 arm64_sequoia: "a2e05e868fc81c74cef1dd6ad5127980e2242087efe70cb3ea16d51e0f61a20f"
    sha256 arm64_sonoma:  "7bce90c178e1f3aa8478d7cc7ad7de9ab9c753e6286e02263d5ca6689b11ae27"
    sha256 arm64_ventura: "c864091fd5665f7d0ef1f9ed276ae3892ce7abe469aa6868b6cb812f52830236"
    sha256 sonoma:        "669d65005c0b5c4085af2b113595612be58f822f36aa96f40f17f872680842c7"
    sha256 ventura:       "a01628dc906a4cb1d29a42a1d7a6a6307b52ed618bcd02ca1fc7b49cc491c02e"
    sha256 arm64_linux:   "b3692d099804bab2bb5dd2df2485e9cddbe5bc940102e109b7e11d71425ad0d9"
    sha256 x86_64_linux:  "f9975302471ad66f568406367d0268189da2fd15ce580de44729004f998806fd"
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

