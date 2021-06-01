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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "03a6d2f3d17961df275ecebc5d3e565e581bc4db09bd08ddb1e5ad794a8a63a9"
    sha256 cellar: :any_skip_relocation, big_sur:       "9050589fd4a39062df4e0d4e2a098fcca843fbc2017383d26b2d1335d476822b"
    sha256 cellar: :any_skip_relocation, catalina:      "a5ca7c2b3717b9e55a849fbb4f13731987f3b24bbfb3b3d0d9b75e1818ec2530"
    sha256 cellar: :any_skip_relocation, mojave:        "cde8bb23af20abe344a16a60fddc6cee6bb8c1d8bf318f8ce68b86b2d4dba9bb"
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
