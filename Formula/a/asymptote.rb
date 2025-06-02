class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/3.04/asymptote-3.04.src.tgz"
  sha256 "f93d27d925fd0bc333d056febe49f2d71f935844c2f8d37aecc8df0fee93c32b"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "836829ed7e3ac91b6041407d135e29b3d786de680e04c3fd419612bc2b5a601f"
    sha256 arm64_sonoma:  "3429250b74bafcb0693afe0fbcd4df056a91c69284f85d3a6826c266f29391e1"
    sha256 arm64_ventura: "dc6ab93369eb6c46ba66c2c082c52b59bd7d834dc01755a0f46bbcf9fb5ecfa3"
    sha256 sonoma:        "b2cae03653b3863a318830398ca2ddce2ec9531788bdfb7419ab23c152d7c94c"
    sha256 ventura:       "30cacff08c12ae7f2db63eef2160ca2c5175829f968853b7ebf7d6b07fdfd0ce"
    sha256 arm64_linux:   "c8066369c59358391d716777978218f8dc8c46c08acfba1c23cd49435a7e3c90"
    sha256 x86_64_linux:  "0d3a0a505096a31a98e6b6907547747872200194249064cb20b3aa503f5985e8"
  end

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
  uses_from_macos "zlib"

  on_linux do
    depends_on "libtool" => :build
    depends_on "freeglut"
    depends_on "libtirpc"
    depends_on "mesa"
  end

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/3.04/asymptote.pdf"
    sha256 "7eeff941b76879316d72dc91fa9cd0efe90d07c10da248b24212a1630c1c283c"

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
