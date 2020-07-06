class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  url "https://downloads.sourceforge.net/project/asymptote/2.65/asymptote-2.65.src.tgz"
  sha256 "15e3d71a0c492c9f2142dd86a7390bcbf59c944ec8b86970833599ff37c59844"
  license "GPL-3.0"

  bottle do
    rebuild 1
    sha256 "6ca74cb50ce6bc7523fd8a36c14f9732722c0b3e2cb7b32e8b951b9ee0ee1c4e" => :catalina
    sha256 "b98bacf73a3bc568f492f76e999e598a6a32d53a5830b6e756cb853eaf4ea436" => :mojave
    sha256 "2404ace2bb76465726c7297a228032c883de1a2ba71aa93557a4ecc93dba0a90" => :high_sierra
  end

  depends_on "glm" => :build
  depends_on "fftw"
  depends_on "ghostscript"
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
