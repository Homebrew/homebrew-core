class Blitzwave < Formula
  desc "C++ wavelet library"
  homepage "https://oschulz.github.io/blitzwave"
  url "https://github.com/oschulz/blitzwave/archive/v0.8.0.tar.gz"
  sha256 "edb0b708a0587e77b8e0aa3387b44f4e838855c17e896a8277bb80fbe79b9a63"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "76ae73757551645b65f9215711c26a43d6dc9ef8226d9812abbf032ee4092921"
    sha256 cellar: :any,                 arm64_monterey: "d63c1a6c2d85a04ee6bd22f26895abac9fe84a818220437c80d56dd022826b45"
    sha256 cellar: :any,                 ventura:        "44d4e4c784f0ef1a896eebac068467b780e90e8e7e8ba38aa6caede688eb5bf5"
    sha256 cellar: :any,                 monterey:       "dcbb61c393f804b7edba2e42caaf7688df8b9693ce4f4956814089f407651c09"
    sha256 cellar: :any,                 big_sur:        "1e65e0e917a0454346801ea361b5186676150edc50f296abcb5f682456375589"
    sha256 cellar: :any,                 catalina:       "c048a4c11493ddfd5222bbfd25934fe4e7981fb7d689eddaef38ac06fa0d5b2d"
    sha256 cellar: :any,                 mojave:         "7bd4d442c43a1f5c2a6fbfbf77faa3d90096873a65d90317fa0dad223908b498"
    sha256 cellar: :any,                 high_sierra:    "5ad4f6c2447b6efdad752ffc05c2d31be8ad1abbe0c6654f77f33141edaf300e"
    sha256 cellar: :any,                 sierra:         "1722c7dfacc458ca54d05dcc06a5281bbe48935f66eaaf7374c2551ad50298a8"
    sha256 cellar: :any,                 el_capitan:     "be9ba4deb07a468b23f430fe2f0896206b120f70e07f94d48267448c0524d3bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "353fd7cf26dc62a4441d2a7498a7d947c163dd0994a9bc2d1da6ef8677525b39"
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
