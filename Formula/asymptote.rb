class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.68/asymptote-2.68.src.tgz"
  sha256 "e1e85a5db14dc809a43189f85415bd0845bcb9eec7aea5533767838d045b02b2"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 "6f1ebb862336eef8285a4b7dee6b4beff0720975cfa6d5927c638c354a62adf9" => :big_sur
    sha256 "6b5ed92e317909ee5dd60b85d76998860f5388391ce4c109277262d47cdcbdfd" => :arm64_big_sur
    sha256 "e0a8838e707147ab51685dfedbeefd089d43e4fac4b6d6743cbd9cf3d714f3c0" => :catalina
    sha256 "300e42702c4b0cb41f14f1a5ddf28930d2b5b73e58a75706a026f85936c68134" => :mojave
  end

  depends_on "glm" => :build
  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "gsl"
  depends_on "readline"

  uses_from_macos "ncurses"

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/2.68/asymptote.pdf"
    sha256 "f41f62e58c7d3199a71136e89749afa7e242f501973d81516e1cac4fae88f889"
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
