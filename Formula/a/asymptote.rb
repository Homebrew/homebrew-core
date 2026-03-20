class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/3.09/asymptote-3.09.src.tgz"
  sha256 "ba733a99fcaaf0c09a8e8f30b46fe4b2be04ea640d2bf034de01886bd1717ae7"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "4c2be38a066de5c264b603c7f5fd00f4725eb3f046034f5b22e1c3137f75c3e6"
    sha256 arm64_sequoia: "290ddf64a54702d1888d2a186b78c36cffb20eb0ba34d7b2a7dcd95a301db11c"
    sha256 arm64_sonoma:  "e7960d2784e878f3b5d4898d7b65f96e9faf92565d4023ea94e101203b741865"
    sha256 sonoma:        "69a63f5e14bd64739e5d0f1a2489462ec97c77713fb105aa5fd282ce3c578329"
    sha256 arm64_linux:   "f62d00e4f17e09acc01c550f82a08235669a0d42295e5d1b899856b2b3ba64fa"
    sha256 x86_64_linux:  "9bfc3f9c60aa6eb60888e5616bc469e2d38b401e79aa0e7fcb4b170fe902981b"
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
    url "https://downloads.sourceforge.net/project/asymptote/3.09/asymptote.pdf"
    sha256 "11ff86e259d339437fc363b954a2b2a1da04d1422c20e2d9bbbe7373208cbdcb"

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
