class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.46.0-source/maxima-5.46.0.tar.gz"
  sha256 "7390f06b48da65c9033e8b2f629b978b90056454a54022db7de70e2225aa8b07"
  license "GPL-2.0-only"
  revision 5

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86a67871890efae4a5e7b45d4e695a745774e5c09b22c950d0be29e8ec37a325"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59ccd0c85e788d1933944160ac78703633a0513290f01932331c74fb384b8d0d"
    sha256 cellar: :any_skip_relocation, monterey:       "e1b0f8a598c743bab5094d02583d0c590590aef9dbfbd0399080b7a142132deb"
    sha256 cellar: :any_skip_relocation, big_sur:        "765d758ced51c1756c0423c1cd9921c4d9afb3845980acea2842c69fc29f1138"
    sha256 cellar: :any_skip_relocation, catalina:       "45cfbe16c195ded0c8ef33d14bb92107e1e7a65afd049df6b6aa9ec6de539092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edc2dbc0a7bcd1318546e0bc3342d6f09acc2c5d1d641a28daf61c147031cf60"
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
