class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.9.0.tar.gz"
  sha256 "b2a3455243187da9a3755da5e5c5c708d9bfdc69d0020db769f610aa6311ea2a"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "eb4c31be3fa7f493b16d840d0ed7e62f356616e9c5af3826d809c4b6e2fa96a1"
    sha256 cellar: :any,                 arm64_monterey: "17050fe339d24ebbbd40e4f979b76687a66cd173692d63cd9e454c43781eca76"
    sha256 cellar: :any,                 arm64_big_sur:  "0a9e815d460fa201ae4bbfce979b930600d2ed8b37700ebc4e31cd35d2bf175c"
    sha256 cellar: :any,                 ventura:        "e96d17b2c2789165f7b002110a9accad4e573332d0fbbf5b81aedcffddfc72a9"
    sha256 cellar: :any,                 monterey:       "b8f692bbff90310bd2c9a53d498d6e018f11e4deda1fc268eff70574df23f6b2"
    sha256 cellar: :any,                 big_sur:        "4b77e27210658817253ce7d467802cf0e9191b2d70c38f97455399863dd99957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "106102f3e9ba2c93d3b9bdedca2bc9cb5e85e117211461840ca617d1abbd1bd4"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg@4" # FFmpeg 5 issue: https://github.com/ImageOptim/gifski/issues/242

  uses_from_macos "llvm" => :build

  fails_with gcc: "5" # rubberband is built with GCC

  def install
    system "cargo", "install", "--features", "video", *std_cargo_args
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
