class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/v2.0.0.tar.gz"
  sha256 "14c88c759cfb5212e656dab66fb2ec9ed1e835627e555cdf76838bb4bde062b2"

  head "https://github.com/toy/blueutil.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "35844a1dc11c167af1f55575c7972dd0c869114adf2d8f235d801463111ebae6" => :high_sierra
    sha256 "0cf9d2cacfabb11ee572ed71a0b5933349492604f5e571d8dc6473862c29cfb8" => :sierra
    sha256 "6f74477ee1d42cf516e1a9d71d522d294a80dbcd250a24aec344c2fd4f6c49af" => :el_capitan
  end

  depends_on :xcode => :build

  def install
    # Set to build with SDK=macosx10.6, but it doesn't actually need 10.6
    xcodebuild "SDKROOT=", "SYMROOT=build"
    bin.install "build/Release/blueutil"
  end

  test do
    system "#{bin}/blueutil"
  end
end
