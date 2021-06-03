class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.45.0-source/maxima-5.45.0.tar.gz"
  sha256 "c7631f32644805cebb7bafef3ab5331c4bacd2c27e384fd88323b5039a60d0d8"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e657b5fdb100d31d40ac096a83ea5c37ffd822675c03c309c1f26ba65c0e3526"
    sha256 cellar: :any_skip_relocation, big_sur:       "97002447ec9d164394bca3167b3dc7485830f8f36e9d1e6235aa3582ef9f9ad1"
    sha256 cellar: :any_skip_relocation, catalina:      "f1121414ac0ce603087e67d2f7abaa4a419e4d90401b0fcaf8abd95f6ba30726"
    sha256 cellar: :any_skip_relocation, mojave:        "beef8e51856c00795f3d0b8b2ca658c147dbde72a320d8c42a844ce74c31a2ab"
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
