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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "24edc61f9292c23bab83aae27656e0d5616ce52465a53ab8e4031fd20852d674"
    sha256 cellar: :any_skip_relocation, big_sur:       "0c8f7bc39372848d209eb00de8b47c02ffb0dced554957206d6448e3ce7e69bf"
    sha256 cellar: :any_skip_relocation, catalina:      "0451e81a6af74d3837c66aacfe6324343f562d60e0d44630ddd90400827772bd"
    sha256 cellar: :any_skip_relocation, mojave:        "dcd67a08d1b42c2c0c1c21ed1f95c25fadabf1685fd8386845c486708208bd07"
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
