class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.79/asymptote-2.79.src.tgz"
  sha256 "9a15dd89c57d15826f51b0fcb93e3956a603f77941bc50acdc71281ea0f00f18"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "451d1aca4788f594bf2db674e85ba3ca7fc44ef570a7ac6b8f36926da15c637e"
    sha256 arm64_big_sur:  "07042331282ffbea83fffe0fa4e165cb72bd8fea89ad8dbe30b9cf79c6e77038"
    sha256 monterey:       "e997ec8d337742445b6dbf4b09e162b5b4de7d79e60a027153996de8328df206"
    sha256 big_sur:        "1a9edb31fda07d3245f75547a7b6dbb100a87454a0ca807162381bb23cff0a04"
    sha256 catalina:       "784a5d2e4c3196b269bbcb5e2ba75f8601938bab0b43e9c93f0d7b4d658cd769"
    sha256 x86_64_linux:   "1e337eb7c36c7cb7158e880117d5dd3e52a2df5739aeb95e3bb90eb74a8ef83e"
  end

  depends_on "glm" => :build
  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "gsl"
  depends_on "readline"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "freeglut"
  end

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/2.79/asymptote.pdf"
    sha256 "9c3fa64abd913dadda189bb7140ca8a3ced6fb73afed94e6e5339953d344e766"
  end

  def install
    system "./configure", *std_configure_args

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
