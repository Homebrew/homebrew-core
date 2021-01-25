class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.44.0-source/maxima-5.44.0.tar.gz"
  sha256 "d93f5e48c4daf8f085d609cb3c7b0bdf342c667fd04cf750c846426874c9d2ec"
  license "GPL-2.0"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "440125b5bf7dbd305b9e548956a6185f9c384cca33fd3eb71106b7e369e41ff3" => :big_sur
    sha256 "c7c4716f8b65fa4e24ac5912d21b5d1785ee7f6497219a6038884aaee682ac1e" => :catalina
    sha256 "1a3edfef96bffeea60b388f2c5d4d52a9b7354c69f8de3bfd29a2a06c51f8af4" => :mojave
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
