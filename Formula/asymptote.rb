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
    sha256 "7de632e13702112a3bd7ea82648f00e7f44e6c53e11e9fe27d5d25a00e6404fb" => :big_sur
    sha256 "386132f253683b60ef9204e88a1545f66ee03bf601e6ffa2d26be8e4d4cddd0d" => :catalina
    sha256 "db70cf85ba7e962682817ba1dbcea83d092dd858ad221f3e398a06f033c4b9e5" => :mojave
    sha256 "04f142eb358b5449850629c2262b268415cd4b3ec5b131ff77338017c4d20246" => :high_sierra
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
