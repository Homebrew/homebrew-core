class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.47.0-source/maxima-5.47.0.tar.gz"
  sha256 "9104021b24fd53e8c03a983509cb42e937a925e8c0c85c335d7709a14fd40f7a"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3045314d149a76e354734f3868324bbc1fa980c78e57d10d50566551a04fedc4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "872f4cbe46544f5b716d0f46f96c0853c95c8118f34802d421911e23477ead1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63b53fe678011ec143a685a3df4a35be9cbfbae4137a0feef7568fc565b723fb"
    sha256 cellar: :any_skip_relocation, ventura:        "48113d4928a0db831c31c9d625b19824439853f47c5482f3f864b3d6d4face2d"
    sha256 cellar: :any_skip_relocation, monterey:       "c2c1630649d716f1c5a68a6427e1313a5c790ac9a2221a380ac16f3c365a9759"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8eec5a0ac03b1d4f144d61a6bf6a634f572da0cd4eeb21bfef2ee6e393ba787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "997ac64a7df682f2d3817cb39762175f4ae9f83f6e43e343923af3282588b5fb"
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
