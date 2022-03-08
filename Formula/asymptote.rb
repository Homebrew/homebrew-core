class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.79/asymptote-2.79.src.tgz"
  sha256 "9a15dd89c57d15826f51b0fcb93e3956a603f77941bc50acdc71281ea0f00f18"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "039658854ae1bfcffc29f6ad60b795f3147d640541ce102f27f415ababadef5c"
    sha256 arm64_big_sur:  "df5c4887cdb26420f8c2d7de8ed3a02081456369d663ad8f8475167d780a3af5"
    sha256 monterey:       "70bf790ce36c4fe25d4068c9b90185a4f17a4cca036a5e71bb60fe0b40b20b71"
    sha256 big_sur:        "0abc10935fc9e423c6dcc8eb8e30240e54a3f1132da3e964014fcce59c29116b"
    sha256 catalina:       "91485910b9687e8fd6482ddc602cdb4e26922f8f24a5dd51b16341aee989829b"
    sha256 x86_64_linux:   "2ee7c356e4450442135ae86f741480e38c0921758c0152857c0957d15a242721"
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
    url "https://downloads.sourceforge.net/project/asymptote/2.79/asymptote.pdf"
    sha256 "9c3fa64abd913dadda189bb7140ca8a3ced6fb73afed94e6e5339953d344e766"
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
