class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://objfw.nil.im/"
  url "https://objfw.nil.im/downloads/objfw-1.4.2.tar.gz"
  sha256 "8e6d0cd39271130a0b6c2789fa08f2598c77d9b88acbd0e2c15c8eb1144baa08"
  license "LGPL-3.0-only"
  head "https://git.nil.im/ObjFW/ObjFW.git", branch: "main"

  livecheck do
    url "https://git.nil.im/ObjFW/ObjFW/releases"
    regex(/href=.*?objfw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "2f7aad89ceb1cafc98c3d560b27a8345f880549fea2a0c2a553af6736f2ade60"
    sha256 arm64_sequoia: "020eac2025b5597f1cd8a1da69d14f76ceb66e2bd440c02e71b53fbc5d4886c9"
    sha256 arm64_sonoma:  "82ebb5e1a9cac88f9203376f25590a2321642a0066a353b4b8c6169dbafb6b71"
    sha256 sonoma:        "1799b4ecdb64a5fc50c79c09dee2ab594444b56da8a3c3292bc9a32c9099a9e1"
    sha256 arm64_linux:   "ee68d1c5c9bbeed79c1abea4ba0fdccd2970b64322e7b68f3f78fe1892c4744e"
    sha256 x86_64_linux:  "47a2062ed7cdb2b7a2e6666363a01d6ace11c39e8fa2111c37204126fd7877a9"
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

