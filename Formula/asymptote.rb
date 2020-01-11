class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  url "https://downloads.sourceforge.net/project/asymptote/2.61/asymptote-2.61.src.tgz"
  sha256 "f3ccaa6fde02a2d37fca771563597828530f94821e1c3fe3a5c7d81e7d398d3d"

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
    # Avoid use of MacTeX with the below sequence, instead of 'make all && make install'
    touch buildpath/"doc/asy-latex.pdf"
    system "make", "asy"
    system "make", "asy-keywords.el"
    system "make", "install-asy"
    doc.install resource("manual")
    (share/"emacs/site-lisp").install_symlink pkgshare # package emacs lisp files
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
