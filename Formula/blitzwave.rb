class Blitzwave < Formula
  desc "C++ wavelet library"
  homepage "https://oschulz.github.io/blitzwave"
  url "https://github.com/oschulz/blitzwave/archive/v0.8.0.tar.gz"
  sha256 "edb0b708a0587e77b8e0aa3387b44f4e838855c17e896a8277bb80fbe79b9a63"

  bottle do
    cellar :any
    sha256 "1722c7dfacc458ca54d05dcc06a5281bbe48935f66eaaf7374c2551ad50298a8" => :sierra
    sha256 "be9ba4deb07a468b23f430fe2f0896206b120f70e07f94d48267448c0524d3bc" => :el_capitan
    sha256 "609c85eec329a8aa988a2b026522642f41b392039936661ce428d13887dfa84d" => :yosemite
    sha256 "af7d02c7520db927c0d835992719922753e89d26588a00a2a53601a1e5aabd8b" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "blitz"

  # an automake tweak to fix compiling
  # reported upstream: https://github.com/oschulz/blitzwave/issues/2
  patch :DATA

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 8d28d78..2bfe06f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -8,6 +8,7 @@ AM_INIT_AUTOMAKE([-Wall -Werror])
 AC_PROG_CXX
 AC_LIBTOOL_DLOPEN
 AC_PROG_LIBTOOL
+AM_PROG_AR

 AC_CHECK_PROGS(DOXYGEN, doxygen, false)
 AM_CONDITIONAL([COND_DOXYGEN], [test "$DOXYGEN" != "false"])
