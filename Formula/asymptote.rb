class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.77/asymptote-2.77.src.tgz"
  sha256 "ae3ddc8e37ae666c75cbd23cd8b42df9c5e95ef6c311b5a2ee4db8b3c643b96c"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "c3923a4ff4fff10888f68fa8eab19f7ae4033feb4de0f5fc16ee6e4aba15c4be"
    sha256 arm64_big_sur:  "ed8e546e8e34f9aca97d70bb9644836a2b8ecf65d9da8a30bebab70bdeff2908"
    sha256 monterey:       "201b0481ff2a96b4684d45cf54bd84f259bfddcd6b1bd03c3f073b822c0f9ede"
    sha256 big_sur:        "c5d6b396ee995f1c1b8c05d41727f030e65b4e742e5cfc6dd508df755f648e81"
    sha256 catalina:       "f0de588bd3dd97f209e360cc2b3063772e50f1e55edbaab8ab1c0c5b6ad2142b"
    sha256 x86_64_linux:   "93b948d43781614896a6f85c5f6394f19c7ba7ee2a0c20d47ad4a4f39722ff08"
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
    url "https://downloads.sourceforge.net/project/asymptote/2.77/asymptote.pdf"
    sha256 "21e23e4721434e9168a88185a58d84e565da7ea09748d85d2c19786ba229542b"
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
