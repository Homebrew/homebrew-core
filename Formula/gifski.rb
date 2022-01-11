class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.6.0.tar.gz"
  sha256 "47733f7b90f40a5ed8abd6cf3a88a4fa9edaaf1a94ae1a996782d118ebc6b740"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7db52af190acca7e1dab68c5746efbe18160ec190448c6ceeffcbf4ca7efbfc3"
    sha256 cellar: :any,                 arm64_big_sur:  "38c427ee4d685a96f1edbdbe270d086115f4ed57f5c87923fd3f1db2437b9a45"
    sha256 cellar: :any,                 monterey:       "e5d491e498349c95632a311016d9beaf2adcc10d74eb46ec7b9c6c4390e4c59e"
    sha256 cellar: :any,                 big_sur:        "ee2064c1977056e1255f9ce14c5415b83b4702b106de2be140d6972481d388b6"
    sha256 cellar: :any,                 catalina:       "c4e3e2288b24e66061d74a3333f33609b1a51684c4a35dd560e1b494db2264c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c42fa9c7d155f6ece86ae7d775823c9ce9814516611b667f9c8a38520bb86cf"
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
