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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf1876cc3a45b25028c16b715370c966a5830b98644793802dff6436e3b269ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e5ab07dc958e30f74506ee83d32f86ab04cd1c92e041fc73395d212655d86dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "829b6a29bb35479309de652c018fb11320bfdef3e74f1a50a9ac36320af66465"
    sha256 cellar: :any_skip_relocation, ventura:       "c97dccd468d2031ecae77282175055c10fc5074327f106d48776af8f72465316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5073e6cd162f677cfec33d6b2b24159d9f14d3bc1ed38997c8b30ca3333de31"
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
