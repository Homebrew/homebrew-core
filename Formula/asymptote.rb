class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.74/asymptote-2.74.src.tgz"
  sha256 "d48e8a5a9029af01da1f845e73c03e78b60c805ab9e974005bcfbeaefaebb3ba"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "35dd1e97fca7edb69bde626f1f503c10275f8b221f71c1840953d4299ca081aa"
    sha256 arm64_big_sur:  "baae14036da02db6e2c5cc8ca637d759d1af8e13a6330bac953c802dc0e00190"
    sha256 monterey:       "a4f10101d0dc819abd76a2150d7bcb429f9eb136e8d83b4faae7a2ac0e34e19f"
    sha256 big_sur:        "8f3a6e7b6baacc43cf517168994b84626484c8f73f75655be5254a616e6ffde4"
    sha256 catalina:       "2ec57ee257c0706bfd1143d27e37c2179dd99a54e33aa882ba522ea13903f07c"
    sha256 x86_64_linux:   "e1765dd33095e894b1ca5879e9480defcf5132249dedd35caf5c85b237e573a5"
  end

  depends_on "glm" => :build
  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "gsl"
  depends_on "readline"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "freeglut"
  end

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/2.74/asymptote.pdf"
    sha256 "16d5e0de4bfba631f548ddf6528f68d11de63f82882c4bcddd45717f97e9a65b"
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
    (testpath/"line.asy").write <<~EOF
      settings.outformat = "pdf";
      size(200,0);
      draw((0,0)--(100,50),N,red);
    EOF
    system "#{bin}/asy", testpath/"line.asy"
    assert_predicate testpath/"line.pdf", :exist?
  end
end
