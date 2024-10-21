class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.92/asymptote-2.92.src.tgz"
  sha256 "9d9b5c6fa7e0fbce3c1e54feb25e2d51d28c4fe7798f24c76cdcae8291a8ea66"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "a2ab1dcc8aec354cde8671c085d0087da9defc0a69b45133235b51722b1da807"
    sha256 arm64_sonoma:  "14e5d0b73d1a8a8d3b75afe56b483bb891171ca9f54733c7c7be1e6bb12663f7"
    sha256 arm64_ventura: "924fbbc0946774ebdb79b1acd8d2b15ac9a99c339381949f8329775bfb381723"
    sha256 sonoma:        "85cb50b11d1bd47bdcfd720da922713a9cac97537b2cee05a97424bdc7e75684"
    sha256 ventura:       "bf56177a8977e92c6aed5bc61f061d7015099a8d659733a7c145c105fcb3cc4d"
    sha256 x86_64_linux:  "26492e1f8f727213bff5d06863fd3869c975687a794c8affa408151a19769592"
  end

  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "gsl"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "freeglut"
    depends_on "libtirpc"
    depends_on "mesa"
  end

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/2.92/asymptote.pdf"
    sha256 "ba96b049da98207eed38eb3be5c306fbd10ff8b00124e26609d5effe7adbdac6"
  end

  def install
    odie "manual resource needs to be updated" if version != resource("manual").version

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

    system bin/"asy", testpath/"line.asy"
    assert_predicate testpath/"line.pdf", :exist?
  end
end
