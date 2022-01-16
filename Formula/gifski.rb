class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.6.3.tar.gz"
  sha256 "4cef85a40868de3ef2fa7d46dda892c16dad492610f143efa129e41fa9248403"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0f9f6f6208e72d38506cf5d314cb5cacfcc2c7d5b8f0248dc837bf647ed21174"
    sha256 cellar: :any,                 arm64_big_sur:  "12458cd8722a0686795b39fe659f5542918b189dbd133146c04acbca8d5cfab7"
    sha256 cellar: :any,                 monterey:       "1ea26d8bb768e9c0bdfeb5db096ce42b5dc76331beefee8239504cb4aa002d46"
    sha256 cellar: :any,                 big_sur:        "95afef5cb18be9f9a388b452e5c150016e8496142412e0ab8df53f063e1c36b0"
    sha256 cellar: :any,                 catalina:       "91720a1eeb136a980abfaaabaaaf746457d75ce3f0df63b73c784f1ffcc76b3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25a471098641629a63b169b84420fa3b70fe623619c0f4cb97b348898309bd3a"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "gcc"
  end

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
