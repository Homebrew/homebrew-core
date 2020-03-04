class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  url "https://downloads.sourceforge.net/project/asymptote/2.64/asymptote-2.64.src.tgz"
  sha256 "8091fe58e8a7eb42dd7c697e5632cfbc1532c0bbf6d5016a755db44fe7af96f4"

  bottle do
    sha256 "64b808892251efca9174dedbca7c7053771d5f6ea84777562a6a92275ba1b50f" => :catalina
    sha256 "ee051fe8dd1b6162d5686c0a0f8a0fc9dd6268c7befc72952721f6f6ab5f7413" => :mojave
    sha256 "cc10a84f49fd48428e79d8f5792335c5b4f4dcf51be79c1a013f946321c7e82d" => :high_sierra
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
