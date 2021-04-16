class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/v2.8.0.tar.gz"
  sha256 "e6b3d2d8ccf52002dcb28e0a255e70344fe16ab14f7d30d4e975049378da85b5"
  license "MIT"
  head "https://github.com/toy/blueutil.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "37623a2b8cb631805e0c032cb7dc0f79fa8b96cb15028405ffa553838e7d2c45"
    sha256 cellar: :any_skip_relocation, big_sur:       "1ee600b762c8198659281e097870d33301fb81455437bf8f9d82f0e0925ffed9"
    sha256 cellar: :any_skip_relocation, catalina:      "3af0bd6588ba4efd71c0fbe0ff9e69d172c5bf060523e943328ca3cf800d3c71"
    sha256 cellar: :any_skip_relocation, mojave:        "9b6b091081fe40d752e37e82943d0e55cd0e5ae78a7323a918cd3d25298c3ceb"
  end

  depends_on xcode: :build

  def install
    # Set to build with SDK=macosx10.6, but it doesn't actually need 10.6
    xcodebuild "SDKROOT=", "SYMROOT=build"
    bin.install "build/Release/blueutil"
  end

  test do
    system "#{bin}/blueutil"
  end
end
