class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.69/asymptote-2.69.src.tgz"
  sha256 "466456077477f9593785af41fcc45bb9a1c0253b40796982d78bf2c7804df79d"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "6b5ed92e317909ee5dd60b85d76998860f5388391ce4c109277262d47cdcbdfd"
    sha256 big_sur:       "6f1ebb862336eef8285a4b7dee6b4beff0720975cfa6d5927c638c354a62adf9"
    sha256 catalina:      "e0a8838e707147ab51685dfedbeefd089d43e4fac4b6d6743cbd9cf3d714f3c0"
    sha256 mojave:        "300e42702c4b0cb41f14f1a5ddf28930d2b5b73e58a75706a026f85936c68134"
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
