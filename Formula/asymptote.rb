class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  url "https://downloads.sourceforge.net/project/asymptote/2.61/asymptote-2.61.src.tgz"
  sha256 "f3ccaa6fde02a2d37fca771563597828530f94821e1c3fe3a5c7d81e7d398d3d"

  bottle do
    sha256 "d1c5cca626e41ea4c04d5b1e8e04baf6d4cf79202e6327bb27fa9e6569b3b63c" => :catalina
    sha256 "ac4d02d92dde24f3fb1e402dbb42ab477c903aed005c3a6fa0b675fb758b8f90" => :mojave
    sha256 "4afce4c3e36e038e9a241338300dec90955faefbc3e77828f860d28537b06999" => :high_sierra
  end

  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "glm"
  depends_on "gsl"
  depends_on "readline" # Remove in >2.61 to use macOS editline

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/2.61/asymptote.pdf"
    sha256 "b5f5848515b6fd6e6d70cebc1b33c45e9d0f00ab7fcf50f71f95e7748c98f5da"
  end

  def install
    system "./configure", "--prefix=#{prefix}"

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
