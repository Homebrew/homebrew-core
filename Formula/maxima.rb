class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.45.1-source/maxima-5.45.1.tar.gz"
  sha256 "fe9016276970bef214a1a244348558644514d7fdfaa4fc8b9d0e87afcbb4e7dc"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "00cf3fb4eaf3e194c6bb0175614c16a4ba465fc33299dbd6eaf54632769aead8"
    sha256 cellar: :any_skip_relocation, big_sur:       "2443561d225319adccf304ff87c4066239eff87244e3c292bed3c3fe7fe2f30e"
    sha256 cellar: :any_skip_relocation, catalina:      "28fee58de710306017aa69b449d3929c7a73feb4dbb4b381760ce2a5e1fcc91d"
    sha256 cellar: :any_skip_relocation, mojave:        "de037bb4344f9d6b82b62700f022d990fd567f397c8e300ccd08a5c3abef087e"
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
