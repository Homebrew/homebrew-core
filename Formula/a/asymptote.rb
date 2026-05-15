class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/3.11/asymptote-3.11.src.tgz"
  sha256 "537e9f22621bf84f09ee0d44dc455c4ea91ba193830f1d7624a07d4710d7e7d1"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "4b53c30735506a03054bcb5067147be8760564623d448bbe9a9bc569f85f612e"
    sha256 arm64_sequoia: "c5a87256201337fb24e4aed889103a077aacd3e3889b573da4796776bb6bc4c6"
    sha256 arm64_sonoma:  "ce4020c6782e95ae2a0af5b0751b91dfbac7c1fdb5c609f430ecaf716f71bd62"
    sha256 sonoma:        "4356e32b547a74ffd6d3e30235412ac71c85823726e71e8cc724c8adc8f830d9"
    sha256 arm64_linux:   "ec376e27021a0cc8cd8e5597c7ab5c0557b799787b645b1afb24d255e953e4e6"
    sha256 x86_64_linux:  "ae074f3b90a7f696b638586a5b70297ba527c08f89f953c5aa5ce2e84b8e36de"
  end

  depends_on "cmake" => :build
  depends_on "glm" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "gsl"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "libtool" => :build
    depends_on "freeglut"
    depends_on "libtirpc"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/3.11/asymptote.pdf"
    sha256 "edfc31f9a54900dcc92fd29535aecccf5e83a38c5843742d7418aaa3baee3802"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "manual resource needs to be updated" if version != resource("manual").version

    system "./configure", *std_configure_args

    # Avoid use of LaTeX with these commands (instead of `make all && make install`)
    # Also workaround to override bundled bdw-gc. Upstream is not willing to add configure option.
    # Ref: https://github.com/vectorgraphics/asymptote/issues/521#issuecomment-2644549764
    touch "doc/asy-latex.pdf"
    system "make", "install-asy", "GCLIB=#{Formula["bdw-gc"].opt_lib/shared_library("libgc")}"

    doc.install resource("manual")
    elisp.install_symlink pkgshare.glob("*.el")
  end

  test do
    (testpath/"line.asy").write <<~EOF
      settings.outformat = "pdf";
      size(200,0);
      draw((0,0)--(100,50),N,red);
    EOF

    system bin/"asy", testpath/"line.asy"
    assert_path_exists testpath/"line.pdf"
  end
end
