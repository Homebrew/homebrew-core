class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.80/asymptote-2.80.src.tgz"
  sha256 "6266d097dc49581f8308a5d3d60a77da11262daa60513c5f2e5b21fea4de1756"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "8974c0e73d690a83c086172e34535a5b9a6ba4a6ec8d6ed74abac7c00f3f8b66"
    sha256 arm64_big_sur:  "03db5cd5630c8d906ecf46a5ab4512e95b4cc7301da54cbb54c8123d3cb6ac27"
    sha256 monterey:       "8a6bce86296179ef977f2ef2957e108875adc76a4b8273d3455b11b5193fa7b9"
    sha256 big_sur:        "2c42a3f1368266de53a3788a4d8eae2cb043f58074dd5730b5b841ccb02cb4a5"
    sha256 catalina:       "a661464748f766aa97111bcb3ec86d58773adc57517a3900cecac7d4d60ef39f"
    sha256 x86_64_linux:   "5da588e0700d85380cc1a5e10ce4219173a3fb02a6a23b98ac6c9907431dcf16"
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
    url "https://downloads.sourceforge.net/project/asymptote/2.80/asymptote.pdf"
    sha256 "8a4d4f4f3d2cfdf83d943b85859af9dc86706f2852301a09c276e9322f5fa556"
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
