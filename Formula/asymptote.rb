class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  url "https://downloads.sourceforge.net/project/asymptote/2.65/asymptote-2.65.src.tgz"
  sha256 "15e3d71a0c492c9f2142dd86a7390bcbf59c944ec8b86970833599ff37c59844"

  bottle do
    sha256 "32021c9290cd44731d37dcd61c96d51d0f319ebd3175f5356b54d2f976a4426a" => :catalina
    sha256 "dc0ad1abac3a55fb3932c6c8a7d97c24d67a8073f6e283b61fc97bf664e1229e" => :mojave
    sha256 "ddf5e782e6bfc87998ebf3b90ab7b0f125d2665b1dd4f8cebb7a4477bae33523" => :high_sierra
  end

  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "glm"
  depends_on "gsl"

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/2.65/asymptote.pdf"
    sha256 "9a3aafacab8e09ca677972321d04c3fe9a335adad960e5f22ab30ab5fb82b705"
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
