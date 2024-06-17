class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.47.0-source/maxima-5.47.0.tar.gz"
  sha256 "9104021b24fd53e8c03a983509cb42e937a925e8c0c85c335d7709a14fd40f7a"
  license "GPL-2.0-only"
  revision 10

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1c44bb0dadbd3e07590f83339bbd86e3b4215afef5b7318656d8e14eb764fdf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41c5bdac39f51815ff70bb25524c47a2f86f25a0ef123d9d7c4b653bb6706b7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e7b69474b75944f67a148973f055a91f428ceb249e3835b89cc592c59cf2271"
    sha256 cellar: :any_skip_relocation, sonoma:         "42bad0e2c24bcdeaddc07401b22f4ffac02a9bf496a4173ca48032195973dd45"
    sha256 cellar: :any_skip_relocation, ventura:        "e9471a2d35707c083a759b515bb9893d51ee654d993ff61308eb36222765c8d6"
    sha256 cellar: :any_skip_relocation, monterey:       "a1a777157ddef25539b9d5dec863f9b68c59036866ce80cf4045336400effae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e43072506f01d860e341ebfad219ae400d6a09ef68602ed0884c4a659c844cb3"
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
