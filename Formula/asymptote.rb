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
    sha256 arm64_monterey: "244016e4c58092cfaa1fb496b527b65ba9ed6f936307cd7be995064770f2db00"
    sha256 arm64_big_sur:  "741c1b1a1d50dfddd5f51ff3235bcc6e3d12a515bfd90b1d55cad7b5088d0ae6"
    sha256 monterey:       "3313fbe94c9e42e1d727ef6cea64323b803061a95921630caa54747b87aadb79"
    sha256 big_sur:        "5d880a2855e1253149ea1d18e171d57f2b7865d54ed2c0ff5e88824ff89ce6a3"
    sha256 catalina:       "b1aea2c1327fdea2ddef9d447c0dac38193bc2fc8ff6f4c2b4bf12fcb8570f60"
    sha256 x86_64_linux:   "8d4ef85ddadfa2240e079e747f1fe4e9fd7c1b148b4f0aaf800c668e388d6126"
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
