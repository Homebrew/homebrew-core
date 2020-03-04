class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  url "https://downloads.sourceforge.net/project/asymptote/2.64/asymptote-2.64.src.tgz"
  sha256 "8091fe58e8a7eb42dd7c697e5632cfbc1532c0bbf6d5016a755db44fe7af96f4"

  bottle do
    sha256 "f9533fe2de225a68b658fe63e382ee52e335875cfbddf7b7ca641ad226615338" => :catalina
    sha256 "1c2ccd8c1686f5af101412ac87f81213d7294f2f97e0939307af52aa870a2b37" => :mojave
    sha256 "164c6a5ed383dbd4c7ceee488ebc1623e65faefcba8090a6a07619c8f8488eb4" => :high_sierra
  end

  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "glm"
  depends_on "gsl"

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/2.64/asymptote.pdf"
    sha256 "53c83d06bb22db555f162d92a15ec6a6941b2db4ce504dae15cabd81e899d87f"
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
