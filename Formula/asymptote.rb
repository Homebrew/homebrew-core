class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.77/asymptote-2.77.src.tgz"
  sha256 "ae3ddc8e37ae666c75cbd23cd8b42df9c5e95ef6c311b5a2ee4db8b3c643b96c"
  license "LGPL-3.0-only"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "c2037ebb95047050e73744bfaf4ff9c706e4bb0e7b9f4b81c61889fcfa43ebe1"
    sha256 arm64_big_sur:  "0c9eb40402f238516acc210972216c9a2e3a79bfc323acb361e5ad639700e01d"
    sha256 monterey:       "ec1772bcbfd4e9c3007cf792e3cfdc1cf93273a61f6a78e54eef04958c5d4b73"
    sha256 big_sur:        "c87636820f6f2beeb6e0db108abc38aa174a09a8d655d23f471e17d50cc14aac"
    sha256 catalina:       "508571d40123f3184b83e751b3234ffbfc5bc9f8c135536a1a7b0f6ed09ff5e5"
    sha256 x86_64_linux:   "5a65a3451610edf2884410dee10e099ee9e909029013bddd065a85bfcc382ea6"
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
    url "https://downloads.sourceforge.net/project/asymptote/2.77/asymptote.pdf"
    sha256 "21e23e4721434e9168a88185a58d84e565da7ea09748d85d2c19786ba229542b"
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
