class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.86/asymptote-2.86.src.tgz"
  sha256 "c4ebad1fc3c7b3ce52d89f5fd7e731830d2e6147de7e4c04f8f5cd36cff3c91f"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "c12ac4a610d83f3dcca34f349e85b7aa21c9d3d090a98bfc3f98541df182fd71"
    sha256 arm64_monterey: "3db950622ff0f9af9e90f212bb5d432dc8cc436a5678a2ffc0558692c2077d97"
    sha256 arm64_big_sur:  "b3ff44aa5d3df47a1066e98b704aac227f399a6539cd3ea8a2d6cb1eee1372ff"
    sha256 ventura:        "dc5a647b7e543ef4eae17b0b7a819be71bf5e893fdf01571b1d2e9d1c6c4560d"
    sha256 monterey:       "881a3aaa436253109c3321d7ec72182478c5dd2f7cdfcac3dd4fd15d416d7bef"
    sha256 big_sur:        "f6206db672499eb6381f93fa308db358f6d157fb17f5c2e0662263eb570014d0"
    sha256 x86_64_linux:   "cef3ad12215b498c2f88690861ac8cac4b8f31d82c0917ad743bc81365fcf690"
  end

  depends_on "glm" => :build
  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "gsl"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "freeglut"
  end

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/2.86/asymptote.pdf"
    sha256 "ea28952b1f6d827a84526709d23b3d2d3003a11a008ff4713bd714ef5c8d1c56"
  end

  def install
    system "./configure", *std_configure_args

    # Avoid use of MacTeX with these commands
    # (instead of `make all && make install`)
    touch buildpath/"doc/asy-latex.pdf"
    system "make", "asy"
    system "make", "asy-keywords.el"
    system "make", "install-asy"

    doc.install resource("manual")
    (share/"emacs/site-lisp").install_symlink pkgshare
  end

  test do
    assert_equal version, resource("manual").version, "`manual` resource needs updating!"

    (testpath/"line.asy").write <<~EOF
      settings.outformat = "pdf";
      size(200,0);
      draw((0,0)--(100,50),N,red);
    EOF
    system "#{bin}/asy", testpath/"line.asy"
    assert_predicate testpath/"line.pdf", :exist?
  end
end
