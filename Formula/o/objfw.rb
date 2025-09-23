class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.4.1.tar.gz"
  sha256 "e223b1cae37453f02ea98f085c3c1f4b78dcf7c16b43d35b05d9ad4480e175b2"
  license "LGPL-3.0-only"
  head "https://git.nil.im/ObjFW/ObjFW.git", branch: "main"

  livecheck do
    url "https://git.nil.im/ObjFW/ObjFW/releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "6aca4ce27dd4ae189df56f2e93c456522480ae64c1ef5bde62bf9d40e807735c"
    sha256 arm64_sequoia: "0c7d1b545a236a8386f7a1d4b6f5951017e55cd47dcaae45e9413e0a53156f0c"
    sha256 arm64_sonoma:  "1d4dd4291cfe1440030e7859666e96a269c06412e361e7a952f4d717d6c5f7d5"
    sha256 arm64_ventura: "cbb86b198299c7fee3140bf71db89417ae8c60ab42bfa04af95bad08686ca07a"
    sha256 sonoma:        "c30649225485166fca5b7d28bded215f2023d8c5c4a922d5d14e79cc0f8a30a6"
    sha256 ventura:       "583848d74371a2b9adb888db1c944ce3adbc350ed2aebcbc5024d0e7a5f5ed21"
    sha256 arm64_linux:   "3a47ab52ada9f1c0a1d44f860a6fc6a31554bd5cfd74bcd80749f1bbdae2fa2e"
    sha256 x86_64_linux:  "5c1bdd1a99f77f672e6dd7083ad25110a15d253519bf49ab0280f62aa3a1b905"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_linux do
    depends_on "llvm"
    depends_on "openssl@3"
    depends_on "zlib"
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

