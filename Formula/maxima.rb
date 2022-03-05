class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.45.1-source/maxima-5.45.1.tar.gz"
  sha256 "fe9016276970bef214a1a244348558644514d7fdfaa4fc8b9d0e87afcbb4e7dc"
  license "GPL-2.0-only"
  revision 4

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c06a235975a72dd1f3441420f3f962aa5d2ff388634bf69f9898d8d30e5d035"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2b30807d9dc4138ad48a027c721d0f2efac636ba244abf81b76e3697e3c0482"
    sha256 cellar: :any_skip_relocation, big_sur:        "7eb3ed75bfe3a2786dc959724c99769c123e9fcc9ac2293ad887c2c280d7e974"
    sha256 cellar: :any_skip_relocation, catalina:       "ffb175c92077e3d87cc659bc888113d656c37a0c3cb75d479a385627a9cd2ce0"
    sha256 cellar: :any_skip_relocation, mojave:         "0d18434459d1c811395e78b2c08ad797332fd34b0d35fe22aa4f409ae6e3500b"
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
