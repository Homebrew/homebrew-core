class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.89/asymptote-2.89.src.tgz"
  sha256 "f64e62b4ee4f85f1a78640c4f1e8a6f98e91f54edacab19727c7cabe94a57f5b"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "2a9a992ac2221d4610bf982c35e6ef4319a8b80b91b34e0448fb0629afe8c7cf"
    sha256 arm64_ventura:  "2b87035d5e1495478f28259e4d967a242330a44ab724c1e6324e60f53eef324c"
    sha256 arm64_monterey: "7fb4ebc2efc1146d3017d74828f26e0280376ec0f117065ad002e6d08f746bf1"
    sha256 sonoma:         "54c61345dbc9c154a00c6a43677285753eead73c6990dd42a7791b1f6a75c043"
    sha256 ventura:        "decf25d56f6fb1c9a190dafe710f210b18b901b895c7c2880ebbb371aa746e3e"
    sha256 monterey:       "cc061c0dff109581cc409d5c0cd6f8a4680bad7d5bd54f4fa142a13a82812687"
    sha256 x86_64_linux:   "5b30497aececeb3440e835cdb8bdf86046113d45cda0dc41f7ad0c94d896fdb2"
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

  on_linux do
    depends_on "freeglut"
  end

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/2.89/asymptote.pdf"
    sha256 "c14f388e05d814462693f04090ad18d9090a5eadd885e5287d1cde3788a5160b"
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
