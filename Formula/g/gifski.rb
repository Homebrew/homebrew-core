class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/refs/tags/1.11.0.tar.gz"
  sha256 "adf9ff87c43900925ac1e0a34cfbccf01072a4b7bfac586d41902fc894a2e457"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dafd6421e40925c2e7ac4bb5f47f87fc1eee195423dff25edfed8fc2e1f63e87"
    sha256 cellar: :any,                 arm64_monterey: "f8f06268a843b83ec4797a032d61915351394ab9008e04f911a4e2a95c7eb810"
    sha256 cellar: :any,                 arm64_big_sur:  "f3fda7cdeffe20e1180e5eb94be43e4eea8d4a2235398bda5ef1e01d1dfa9d4c"
    sha256 cellar: :any,                 ventura:        "3f78ab9650301289019f130bd46d598cbca3809525150e546931289099d92707"
    sha256 cellar: :any,                 monterey:       "1762de93993957a3e246ff6afad186fdd21574d058dfc289dc3f0f31de25dd26"
    sha256 cellar: :any,                 big_sur:        "160d8491c520971c69517809ae0f704b53a7508bb132239b4910409418e91565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55666d678313d62f7585b9df2bccece76642be2664d4db6ce95a96d979a9ee8d"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

  uses_from_macos "llvm" => :build

  fails_with gcc: "5" # rubberband is built with GCC

  def install
    # Delete config.toml to avoid targeting newer CPU. Remove in the next release.
    # Fixed upstream: https://github.com/ImageOptim/gifski/commit/7e31a4c45def29b9e9c082460ab02a28f0e8730e
    (buildpath/".cargo/config.toml").unlink

    system "cargo", "install", "--features", "video", *std_cargo_args
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
