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
    sha256 arm64_sequoia: "4c9acb6b2cbb4c5f60327bc0b45eaded42f416f56efcaa4b079b1841b563e486"
    sha256 arm64_sonoma:  "e07a67967f009dad95cac824238475e5509ddabb2908c8a8318ed600b54bef8c"
    sha256 arm64_ventura: "c2263362599830bcb994be5ec834960386f52542d8aed892837c418d6b821fb8"
    sha256 sonoma:        "105960305b587763883ef15b78e9babb71bd74d64328e37d4c438ab4dbaedfe2"
    sha256 ventura:       "e13c3bf6a4a1f6d389d75978d3c8ccc3236d0c599a4c24b133a024dcf48274fc"
    sha256 arm64_linux:   "02e8e1ec91e72f84e041911ab4fadd221c5d54d78b3660dcd84d4d705a028f6d"
    sha256 x86_64_linux:  "abc0b34c221438f218cb7b667bde87c888d05a1c6f4bafe333e2052d668305a4"
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
  patch do
    # Fix building for macOS 13 with old SDK, as used by Homebrew.
    url "https://github.com/ObjFW/ObjFW/commit/2d297b2d3702d24662819016b57f0a67d902990d.patch?full_index=1"
    sha256 "39ccc15f5f5123dae4c86ce6dfbb21ce08a4b4b600e6d6faa19268657e5cf3e8"
  end

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

