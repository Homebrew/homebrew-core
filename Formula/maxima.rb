class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.46.0-source/maxima-5.46.0.tar.gz"
  sha256 "7390f06b48da65c9033e8b2f629b978b90056454a54022db7de70e2225aa8b07"
  license "GPL-2.0-only"
  revision 10

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24d75d148fc9cecb73dd7c2d03bd51440e990c606e8075b8ff533e170f0eb3a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7547c885ab2b0f04b3662ca382c3d4972cf855157c4767f12b05ecdfc92d01c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bf65e38e6bc4c5af48dc7d0d6e37fcefb32b2a87320294961daaff5f703ac72"
    sha256 cellar: :any_skip_relocation, ventura:        "2d950d5204cb21636f4e2b4b327b9d23a9abfd45ba4108f97ce4645c03efbb3c"
    sha256 cellar: :any_skip_relocation, monterey:       "53f72622348b171d26a5829e98b45d864b47832b714989ec406a790f26f657a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "bacf145bb9fc4f318eeeb6ce40f7e22d15c6cda4c1c977a746fede9703942518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da5e31a5d500b65bdbd53ea25f875e61e99cfb5539ef2f74f2e17338db811c55"
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
