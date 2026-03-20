# Based on:
# Apple Open Source: https://opensource.apple.com/source/cvs/cvs-47/
# MacPorts: https://github.com/macports/macports-ports/blob/master/devel/cvs/Portfile
# Creating a useful testcase: https://mrsrl.stanford.edu/~brian/cvstutorial/

class Cvs < Formula
  desc "Version control system"
  homepage "https://www.nongnu.org/cvs/"
  url "https://ftpmirror.gnu.org/non-gnu/cvs/source/feature/1.12.13/cvs-1.12.13.tar.bz2"
  sha256 "78853613b9a6873a30e1cc2417f738c330e75f887afdaf7b3d0800cb19ca515e"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]
  revision 4

  livecheck do
    url "https://ftpmirror.gnu.org/non-gnu/cvs/source/feature/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "12f7b6ba364b0131ac464c51dac10844da7be696fa3ec85b2aaa5ab0ee10fbce"
    sha256 cellar: :any,                 arm64_sequoia: "0495f3e13e3d8eb8a04fcf144bae83551341c35d8f4cfe2d9b11427dc49f34fe"
    sha256 cellar: :any,                 arm64_sonoma:  "f8dade380a6cf039b4a15971a46dc9201dcf5c9d9acedd694f4adfa04368495b"
    sha256 cellar: :any,                 sonoma:        "d23f89d868c88f29bd4447915da42d8e5eb4e9efeb05d83e41adbf031f967bce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3f13423ddb87b2c109ef4a83bc27adb7cfb2fed004e76d1b8902f7b5c8ee856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eb7d12ce9a3935d6c1caad26fd473cfad09f4e22dcba970fab57ab5f8dca9c6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build

  uses_from_macos "krb5"
  uses_from_macos "libxcrypt"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "vim" => :build # a text editor must be detected by the configure script
    depends_on "linux-pam"
    depends_on "zlib-ng-compat"
  end

  patch :p0 do
    url "https://github.com/apple-oss-distributions/cvs/archive/refs/tags/cvs-47.tar.gz"
    sha256 "57652695bbfbc33eacb8f1ecb3ca5e2df0f773e4abb307b840bf948e3840f3d3"
    patches = ["patches/PR5178707.diff",
               "patches/ea.diff",
               "patches/endian.diff",
               "patches/fixtest-client-20.diff",
               "patches/fixtest-recase.diff",
               "patches/i18n.diff",
               "patches/initgroups.diff",
               "patches/remove-info.diff",
               "patches/tag.diff",
               "patches/zlib.diff"]

    on_macos { patches << "patches/nopic.diff" }
    apply(*patches.compact)
  end

  patch do
    # Fixes error: 'Illegal instruction: 4'; '%n used in a non-immutable format string' on 10.13
    # Patches the upstream-provided gnulib on all platforms as is recommended
    on_macos do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/cvs/vasnprintf-high-sierra-fix.diff"
      sha256 "affa485332f66bb182963680f90552937bf1455b855388f7c06ef6a3a25286e2"
    end
    # Fixes error: %n in writable segment detected on Linux
    on_linux do
      url "https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-vcs/cvs/files/cvs-1.12.13.1-fix-gnulib-SEGV-vasnprintf.patch?id=6c49fbac47ddb2c42ee285130afea56f349a2d40"
      sha256 "4f4b820ca39405348895d43e0d0f75bab1def93fb7a43519f6c10229a7c64952"
    end
  end

  # Fixes "cvs [init aborted]: cannot get working directory: No such file or directory" on Catalina.
  # Original patch idea by Jason White from stackoverflow
  patch :DATA

  def install
    # Do the same work as patches/remove-libcrypto.diff but by
    # changing autoconf's input instead of editing ./configure directly
    inreplace "m4/acx_with_gssapi.m4", "AC_SEARCH_LIBS([RC4]", "# AC_SEARCH_LIBS([RC4]"

    # Fix syntax error which breaks building against modern gettext
    inreplace "configure.in", "AM_GNU_GETTEXT_VERSION dnl", "AM_GNU_GETTEXT_VERSION(0.21) dnl"

    # Existing configure script needs updating for arm64 etc
    system "autoreconf", "--verbose", "--install", "--force"

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    system "./configure", "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--sysconfdir=#{etc}",
                          "--with-gssapi",
                          "--enable-pam",
                          "--enable-encryption",
                          "--with-external-zlib",
                          "--enable-case-sensitivity",
                          "--with-editor=vim",
                          "ac_cv_func_working_mktime=no",
                          *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    cvsroot = testpath/"cvsroot"
    cvsroot.mkpath
    system bin/"cvs", "-d", cvsroot, "init"

    mkdir "cvsexample" do
      ENV["CVSROOT"] = cvsroot
      system bin/"cvs", "import", "-m", "dir structure", "cvsexample", "homebrew", "start"
    end
  end
end

__END__
--- cvs-1.12.13/lib/xgetcwd.c.orig      2019-10-10 22:52:37.000000000 -0500
+++ cvs-1.12.13/lib/xgetcwd.c   2019-10-10 22:53:32.000000000 -0500
@@ -25,8 +25,9 @@
 #include "xgetcwd.h"

 #include <errno.h>
+#include <unistd.h>

-#include "getcwd.h"
+/* #include "getcwd.h" */
 #include "xalloc.h"

 /* Return the current directory, newly allocated.
