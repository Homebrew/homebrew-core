class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.70/asymptote-2.70.src.tgz"
  sha256 "f5cc913a858c33e92f79ab421d354c0fe2babd87f452ae9dff729a902aa80c3f"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "51b5992d115848c87754a30dc0341c73119294eb80f882b2ccf363215b276715"
    sha256 monterey:      "43fee389478b409929b52ae0bbf32ca37d3dbd6628f2b041aa9d9ce9527caf2d"
    sha256 big_sur:       "d6631cfaf7909cfd8a38c7e655411b69248d395531589f7562b66b36ad9ccedf"
    sha256 catalina:      "b906f3cbeda2861975792c6279df7c2e22738c8ae232bfb5e4cf4ec1a37c0725"
    sha256 mojave:        "c7d65e0093978726a703585d8155862b1b7e10ba47f531f907c106b65bead23c"
    sha256 x86_64_linux:  "f3918cb9c194f0eb86d9b86d5ce4d6fcb721214a70b9e9e7658a547d6490e635"
  end

  depends_on "glm" => :build
  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "gsl"
  depends_on "readline"

  uses_from_macos "ncurses"

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/2.69/asymptote.pdf"
    sha256 "d87538cadf1af08ef2217165de6b88b0520eeb67a9e5f1a6bb8f9e3f67e09704"
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
