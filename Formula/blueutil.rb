class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/v2.5.0.tar.gz"
  sha256 "0a37a3476018b9f8489f0d8685c122da177d80075924ef68689997188a7ce132"
  head "https://github.com/toy/blueutil.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aaa5f3d72a8abd32e6e19465a0d1b1061dcb694ca5552dd3fd44384f4be3707e" => :mojave
    sha256 "00ac1b7cfb54b05a27c4ef31cad443a7c7ad00bc56adc77acde00d14c0e0a566" => :high_sierra
    sha256 "68094b894edbcade821591c699cd5349ff42995db389694ac7c6c22af0d4182e" => :sierra
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
