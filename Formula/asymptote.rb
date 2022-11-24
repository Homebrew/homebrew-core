class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.83/asymptote-2.83.src.tgz"
  sha256 "fe3ca71f49e59e68633887c41613c08abd82a749fcac30353970ac7081b388a3"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "00722f7054eb070ab45da269cb855d8bfd0abde56cfa88a044f439616ee7dfec"
    sha256 arm64_monterey: "c5044dfe0019602c9e14206d9d60ade8da007d9e669a78847a1b0696fd4a0b1e"
    sha256 arm64_big_sur:  "c902d4ce6d6f9d6d524d2b7dae26a003596ce880ce89657b86a09fe801c5c175"
    sha256 ventura:        "ab3416122189a594297aa43fa632b2d809d57e82ebbfc9e4057b984c157e517f"
    sha256 monterey:       "6cf12080a479ee58c9c35adaf1454ef4db18c439ba47c2906b6c6f03c85b99bd"
    sha256 big_sur:        "329d4519c3786d308fbf90e4036acfb53c532e62cf75e75738ddeeded7c1ee82"
    sha256 catalina:       "2273f743a5f264432d22bc80671327ca24f97e36cb99048f203df2c903f30cda"
    sha256 x86_64_linux:   "dd0020ddf62cc2b15d0852add6bad93874deb98d76c70838a428f3e3a7a5b81d"
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
    url "https://downloads.sourceforge.net/project/asymptote/2.83/asymptote.pdf"
    sha256 "8a458aea0cd96b2d9ff8b94e59ff55e0ab83b3e6224c2124d7649b43a3bc36bf"
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
