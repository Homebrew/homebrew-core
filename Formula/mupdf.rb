class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.19.0-source.tar.xz"
  sha256 "38f39943e408d60a3e7d6c2fca0d705163540ca24d65682d4426dc6f1fee28c5"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git"

  livecheck do
    url "https://mupdf.com/downloads/archive/"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "505e822fa5a236b30d111b425c7468877b4a4d4f70627e4249c2e50831cefb19"
    sha256 cellar: :any,                 arm64_big_sur:  "a7c433b107bec1ae16959302f426bbf9eed5144efd3db390bd50a5a993d17029"
    sha256 cellar: :any,                 monterey:       "cbe4b42ae97e626ca05a7645c4d7ac8cd0d36c73b8328c13b132253c733cbd53"
    sha256 cellar: :any,                 big_sur:        "d4d5eb0345a58ffb91e4119dc2c1204d0383ce9cf31a9a0e21b8b69be9e34e04"
    sha256 cellar: :any,                 catalina:       "ce072c384dc4f09671d8b2e531f4bf2a9f6c7a6fb296be86a56d39d3a9d20582"
    sha256 cellar: :any,                 mojave:         "9d6f5c2e18ac29be5611c6a4f7c00fe39d56ab61f96a85156c351f5bb491bace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8514c022a9d5f79690aeaa1eac668abfe06c445e7e66382e0887a2674a634de4"
  end

  depends_on "pkg-config" => :build
  depends_on "freeglut"
  depends_on "mesa"

  conflicts_with "mupdf-tools",
    because: "mupdf and mupdf-tools install the same binaries"

  def install
    glut_cflags = `pkg-config --cflags glut gl`.chomp
    glut_libs = `pkg-config --libs glut gl`.chomp
    system "make", "install",
           "build=release",
           "verbose=yes",
           "CC=#{ENV.cc}",
           "SYS_GLUT_CFLAGS=#{glut_cflags}",
           "SYS_GLUT_LIBS=#{glut_libs}",
           "prefix=#{prefix}"

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end
