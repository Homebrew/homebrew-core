class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/3.02/asymptote-3.02.src.tgz"
  sha256 "6796de739dde956c30c689fb0cf3927a71147b4961a37d883933e027133fc70a"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "67f15e6b7d17e0385699acf4eebc33a38f1f67e79b6cd95efe44577520969d1f"
    sha256 arm64_sonoma:  "c8de9421dbd32ea9db35db3e59128fa295cf798927af145005c514685aadc3de"
    sha256 arm64_ventura: "8980e8eb202cef2dc3a700ce3eb2a94e9d91e3c622bee708edca72a8ccab5055"
    sha256 sonoma:        "70e4febd6d1122b2686e3d4ac514427fc4c3f1be969222e7acbb60bbcb343968"
    sha256 ventura:       "6c42ca247cc3863cf6abe840b7fdd228347b16cfb3288b6903d4fe0d73c0774d"
    sha256 arm64_linux:   "8acb662cb0391fbcfdca9c1225332f96a85debba2076427b6d4a5df4b5d37092"
    sha256 x86_64_linux:  "d16f7a686b15adc49bf5553d98e7a33aaf768a4b6d8025674e17cb5046c75ba9"
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
    url "https://downloads.sourceforge.net/project/asymptote/3.02/asymptote.pdf"
    sha256 "660bb9d9100c90e7d43d615d3245510c8d9fba4a76c84ef5b0dca7d171e58f09"

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
