class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/v2.4.0.tar.gz"
  sha256 "1697e6b8522841bf12208826ca22b164f83029a6196f28a0b00dc79d0d8252a5"
  head "https://github.com/toy/blueutil.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "16cdef80b486f0ea1688383e182761e296b4666108acd7786033139260844f31" => :mojave
    sha256 "8f373fa0ddda43ed43c883789c00b4e88ec597e0dc625195cb8b5d889a5a1239" => :high_sierra
    sha256 "f763a5f16cce873c8f2e6e355dac000f039a7866e0632c79805ddbdfa4b5ffec" => :sierra
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
