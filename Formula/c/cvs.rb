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
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "9db42bbcbdc91ec57b9c1039d1e44c4497322339705b60c38573d07beb644b3d"
    sha256 cellar: :any,                 arm64_sequoia:  "395bcc270613244fc0be159a5cc843cff6696397961958634363d4b1a2241454"
    sha256 cellar: :any,                 arm64_sonoma:   "e561f130192a57e7fe98eab345f97fd548bdabb62e78a9131a91c3c87f0a4429"
    sha256 cellar: :any,                 arm64_ventura:  "b04bc5783e3ce63a89075a9f824c2f3257ddb6974f22827315bd2848a0d96a05"
    sha256 cellar: :any,                 arm64_monterey: "facb582f400a539914188f2c526148db296f6a9c626b298b6749a528a6955b6e"
    sha256 cellar: :any,                 arm64_big_sur:  "69072386044a5fb88c0855933f336ada641c7d4f0b5a26859b83609de094d975"
    sha256 cellar: :any,                 sonoma:         "242d715445ff0ce9c2a1968f51b2c15c5aef9069a7f0c957d79cd9dd01069f75"
    sha256 cellar: :any,                 ventura:        "12844f5aacd63941b0751fcda0524b48b3846caf9f5c348b132408d320e22bcb"
    sha256 cellar: :any,                 monterey:       "90e39df5b90cb3ae770fb19ec618350b02e7c16ca1bf5748cddbb2302c7f764f"
    sha256 cellar: :any,                 big_sur:        "f82f03a64e86b956f63f2a9b420bb6db7f792bcc65e829278def0939fca4b947"
    sha256 cellar: :any,                 catalina:       "0d792dc4be608c3abdadc97ba8fabca3d72a94e8903c9516ca529d51eb6fe2e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8a0ae39e62086e0c6ee0bbb9843d6fbdaf09164b07a288c6dcccf2995acb9dee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9ec7ba1c5450d7df8c3c5f623579a78ba970b29eb1dcbb991cfcfc5ae2630d2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build

  uses_from_macos "krb5"
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "vim" => :build # a text editor must be detected by the configure script
    depends_on "linux-pam"
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
