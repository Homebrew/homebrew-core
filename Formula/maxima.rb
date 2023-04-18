class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.46.0-source/maxima-5.46.0.tar.gz"
  sha256 "7390f06b48da65c9033e8b2f629b978b90056454a54022db7de70e2225aa8b07"
  license "GPL-2.0-only"
  revision 11

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6af1f051897d7d2e3b8c34bd6372cf261949d13b7e0d851d3b8c07ed084c0dc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ded6c885075637b4dcfa806105766be60d27153838db33f91aad1ca033275195"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6be619c0001b79386778c089a677f3cb1861dbbd1d2f09b235b79a2cfc9f52b2"
    sha256 cellar: :any_skip_relocation, ventura:        "ff9298f5b8328e7ec99b04e93bdb0be972cb92469eea9a0ae70019a9c4872590"
    sha256 cellar: :any_skip_relocation, monterey:       "61a8ec2764b28f84451d23b5eeedfb8d0589f140848c96ef3a1464ea34b0bbf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f268ff3f27b81d8a87cd1be6b186a60c1fd5a45eb3094f77a3cf273bcf6f879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b1b5dbfb92ad401dd3a8fa836d2ae526e9fa97c2f4dc4367048f2a5a48f7bd1"
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
