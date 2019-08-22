class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/v2.5.0.tar.gz"
  sha256 "0a37a3476018b9f8489f0d8685c122da177d80075924ef68689997188a7ce132"
  head "https://github.com/toy/blueutil.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "90fb9709312067ec916bb65266a0784f49a11616fce4f9696d9285de8404fac0" => :mojave
    sha256 "45c310afd6b5251bfe0ec44328f4c1f5e0857bca197cbef5039e99d409c9c5f9" => :high_sierra
    sha256 "295a951fa7f8681a621d57266d0145a3b902bd34b56f676e69ff193d8a16594c" => :sierra
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
