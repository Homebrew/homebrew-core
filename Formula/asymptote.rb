class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.81/asymptote-2.81.src.tgz"
  sha256 "768eba48c877373a810d991d482f88480643291aae68fa2abc3aa3d5a7ed0073"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "24dafab10c9cb3ce25a5cd58d535b9d483ec1844204f6c6073d1a7e530f2ff82"
    sha256 arm64_big_sur:  "ccd8fb43d61926ddc356291e90bdce81b0a11f7dd97a522f340a647644082280"
    sha256 monterey:       "09bb8447e714ecfc704289df1a3fcbe30623dcafca4f3539f15685c3da0c9a0c"
    sha256 big_sur:        "37f8f552883033592490b83f02da1177356ecddadd0cefdb2e5efc0ac1761ccd"
    sha256 catalina:       "872c509ade405f97b9c35c278118548203ac6a4b6ca9f5ba62460a5efc24ae54"
    sha256 x86_64_linux:   "7ffa5e3c133c0f8c5be864053fbc94a073299371e2562a4b0e3938eb6368b55b"
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
    url "https://downloads.sourceforge.net/project/asymptote/2.81/asymptote.pdf"
    sha256 "543c3a9a87292c76083953688db28e20eb33d7f2e67e7808454f7e3d136de930"
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
