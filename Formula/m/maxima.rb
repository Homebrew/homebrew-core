class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.47.0-source/maxima-5.47.0.tar.gz"
  sha256 "9104021b24fd53e8c03a983509cb42e937a925e8c0c85c335d7709a14fd40f7a"
  license "GPL-2.0-only"
  revision 23

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1504157234aee064744b46329cc7ddbadbebc76531c96ec565fa3f6fcebbc6ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55533e9b6bc22937b39f5767e18f94a8148d219a4551a79395fbf9b6b42920dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3392051fbf077ddd9e5a40164e64964fe33e556696481f692ab471cf89fc82c9"
    sha256 cellar: :any_skip_relocation, ventura:       "b30fdd46eec5609a4691b2b1a9827bf925a20b2fba786a5c730a7923b017803f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfb2478d571e65e8e8bae71dfcfdbcbe6176a8a33fe12bdb63973f14ee841c48"
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
