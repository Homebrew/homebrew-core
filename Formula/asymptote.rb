class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.75/asymptote-2.75.src.tgz"
  sha256 "9c8b3fe89df45e6e799ef422fe7231fe87ba681908364eb0cd08b51910476c77"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "bc36b73452d0d9986d676b44f6cfe1fe66a90765ea2e776a978a47d3ccea35fe"
    sha256 arm64_big_sur:  "2527026c063bf26d17c27b70d4832dc8224e1162df48f351c5c9c8cd8c8c9f4c"
    sha256 monterey:       "e1fbc082c18d809f85d657ad3206fe6b184c5215d1b786b23d5a9fb6a5536406"
    sha256 big_sur:        "334094e612c41a0072bc3027a6e85463b44ad156f0c6ac9250bd531798aff539"
    sha256 catalina:       "f62ae59ffce773212dc8a2dd01f91304ac72be5eb339ebe7db7938593ed8fb3f"
    sha256 x86_64_linux:   "21ce391dc447e2f165622459a0fee6ef7b823ec2e833ddfa9154b8784656bcb9"
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
    url "https://downloads.sourceforge.net/project/asymptote/2.75/asymptote.pdf"
    sha256 "090fb10f9a2cb58781af38974cedd64ea1d7a9f4b0a379660b1a0fc9688654ca"
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
