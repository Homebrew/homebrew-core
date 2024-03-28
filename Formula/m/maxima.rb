class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.47.0-source/maxima-5.47.0.tar.gz"
  sha256 "9104021b24fd53e8c03a983509cb42e937a925e8c0c85c335d7709a14fd40f7a"
  license "GPL-2.0-only"
  revision 8

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6b6bd49172b9c29c153b947f2d6c993f764fd1a24739b7e84ef9e5da818f980"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "404a06558fb3a0d9f93455106ac7a0bc37c173962c61bc002fbe484aea6e5dd9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26aa87f5a0fed5c44f47fd4fe063791ad41f7d0e3e7888a2f2b7e50015a13594"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac9cae0720609b2cad4be511c297b7b1ec385ae553c613fce06ff4cf73568a4a"
    sha256 cellar: :any_skip_relocation, ventura:        "4963ff3425c8a112db32cb71b84cab86feb55cf86e2e0ea82b6bd7ae434ef478"
    sha256 cellar: :any_skip_relocation, monterey:       "0c016a84e70cc42903995d59cc024825040c44b153fc8d44b5a47bca0d3345e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "671b6e07c16b91128f1afbcea13b9a236c415f3afc33bf0be2bcf8e49dcbf112"
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
