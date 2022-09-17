class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.83/asymptote-2.83.src.tgz"
  sha256 "fe3ca71f49e59e68633887c41613c08abd82a749fcac30353970ac7081b388a3"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "4784ec0590b2dd8af194008fc9c33d89035762f579d0d44d60ddc16f2c4cc75c"
    sha256 arm64_big_sur:  "ab9f9655049e0e406046cccfa56425226d64c5ae76329f46ca39529f5d117428"
    sha256 monterey:       "fb203e04b75e5c1034f7afece17ec41b601143ecf2d3d3d336b512b63b0a53d6"
    sha256 big_sur:        "ed81192f92d5c258a5ca1a6d2d4dde3bac89f42f0c8f592c276b5cf976f357bf"
    sha256 catalina:       "603b162fc137b2014bbc10aeffa0dd80bfafa51fb45bdc030dfcaa877f907224"
    sha256 x86_64_linux:   "a7ac112a23b63fb687619a714c2a72baa070c4f72e8c512e5647daaefdedc2a0"
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
    url "https://downloads.sourceforge.net/project/asymptote/2.81/asymptote.pdf"
    sha256 "543c3a9a87292c76083953688db28e20eb33d7f2e67e7808454f7e3d136de930"
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
