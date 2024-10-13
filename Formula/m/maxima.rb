class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.47.0-source/maxima-5.47.0.tar.gz"
  sha256 "9104021b24fd53e8c03a983509cb42e937a925e8c0c85c335d7709a14fd40f7a"
  license "GPL-2.0-only"
  revision 14

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f4c8d126981cde367e0c4ed884c5211c6615e01ddcabf6d9d4a030080cb384b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed5688d2f920624365a04f2aca441a7e2667927340ba1a97f56684add83cf3f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "305feeb086315fc27a10edf6fe88f5c42309e0bea51510f82c3dad7cedf47ed7"
    sha256 cellar: :any_skip_relocation, ventura:       "836fb583af4714814493cbba9639dbb15493cf1fb365eb9699101fb70ecfcf64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3c047cef0016317357b2d14cb2f7c2709472cac3648156fc77e6f341baafd35"
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
    system bin/"maxima", "--batch-string=run_testsuite(); quit();"
  end
end
