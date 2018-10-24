class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/v2.2.0.tar.gz"
  sha256 "ad6c8d15896cbdf5526b85aac57df02f6e00aace178e2f6c5208256f9525e99a"
  head "https://github.com/toy/blueutil.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5bf587580f0e5c125b111411b9fbe58185eca7f523b1aa854af752709d3de959" => :mojave
    sha256 "4c3653d05a0b18bf2eb430c71236615e6c7bcf4d2317d30eceabb4baf79f0587" => :high_sierra
    sha256 "a27c0893c6d6cd7370ae468e944693a3512ecc933c082513974666db3f25e6a9" => :sierra
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
