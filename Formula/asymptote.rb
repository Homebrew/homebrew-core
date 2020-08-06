class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.67/asymptote-2.67.src.tgz"
  sha256 "8a1e574b81140b3fc1f5be659468bf90a313255a5a548ddd9fd11d4155e72d9b"
  license "LGPL-3.0-only"

  bottle do
    sha256 "dc6d4f13df8030bb0cd0040cd6372af6f0bd7b94cb369821b73d5cb3d996b91f" => :catalina
    sha256 "1c2d88dfbe123512db773d1499a8e21d4c759ce72099ce02c30f7f46be8a3b41" => :mojave
    sha256 "2314a6f120bdeef1e01083c501edc4d5519cf6e0e4ebe805bb3dc6f17bc7c66c" => :high_sierra
  end

  depends_on "glm" => :build
  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "gsl"
  depends_on "readline"

  uses_from_macos "ncurses"

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/2.67/asymptote.pdf"
    sha256 "f1412782e639612050063eb66fcca6ecca415b1141b2142b3a310ccb21509694"
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
