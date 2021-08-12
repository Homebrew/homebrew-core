class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.45.1-source/maxima-5.45.1.tar.gz"
  sha256 "fe9016276970bef214a1a244348558644514d7fdfaa4fc8b9d0e87afcbb4e7dc"
  license "GPL-2.0-only"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "666f50b921d8f95baf15b9536ada2b031c94dd1f213ed9f3e75b71baf97ec2f0"
    sha256 cellar: :any_skip_relocation, big_sur:       "d3975b44c06748e90bea5dc18ff1550a10a964d595376551de72700cbbd4e130"
    sha256 cellar: :any_skip_relocation, catalina:      "dcf02539af51157b23f0dc57fbe58f74105fe1d45e1dc6776d56a563ac64e3e1"
    sha256 cellar: :any_skip_relocation, mojave:        "ba344ccfc0391cb38929cece0a18ea94d8ebac498e2c708faeb6ec7276b30041"
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
