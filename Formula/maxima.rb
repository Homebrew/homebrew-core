class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.46.0-source/maxima-5.46.0.tar.gz"
  sha256 "7390f06b48da65c9033e8b2f629b978b90056454a54022db7de70e2225aa8b07"
  license "GPL-2.0-only"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c27242aecd6fb996bf3909212659022687c0add1499bb4854a1e75ccf5f19c58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f2f6c70764e9aaa9e941412e1ccf39f7249e85f307dc336691506ac674dbb5d"
    sha256 cellar: :any_skip_relocation, monterey:       "f9deb56836b13444fb2da43ffb16a6fe569c7587cc5cc43f91d69d2fce750aa5"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b70df5052dedc5f0ff4458b2f789ae0d1db0e050cdd9685a41c94ee2821de1f"
    sha256 cellar: :any_skip_relocation, catalina:       "89464ea8778169e2f6f5fa9f3d40bd871f7444014a2bcbeba3cb061e1bb0df19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdfc75e38d7bce119e1595392cdee343823ba5083a0d847aea9cb48bd8dfab42"
  end

  depends_on "gawk" => :build
  depends_on "gnu-sed" => :build
  depends_on "perl" => :build
  depends_on "texinfo" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "rlwrap"
  depends_on "sbcl"

  def install
    ENV["LANG"] = "C" # per build instructions
    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--prefix=#{prefix}",
           "--enable-gettext",
           "--enable-sbcl",
           "--with-emacs-prefix=#{share}/emacs/site-lisp/#{name}",
           "--with-sbcl=#{Formula["sbcl"].opt_bin}/sbcl"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/maxima", "--batch-string=run_testsuite(); quit();"
  end
end
