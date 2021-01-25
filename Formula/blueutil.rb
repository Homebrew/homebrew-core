class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/v2.7.0.tar.gz"
  sha256 "1b171abdadb008cc7f3dac6e647c000d4ae89246c27a8b2926e56643deb1e422"
  license "MIT"
  head "https://github.com/toy/blueutil.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b868d1f1e57fe70234b70737b333aa528312e35e87b914c896e12265c83c2ae" => :big_sur
    sha256 "b2994b6cd6195329f784c50dc77503fefdba555d31498d2a2b4966e771890352" => :arm64_big_sur
    sha256 "7ab6e3a2ee2545185668cdf4adda1b99c98fc381148c8c73db14dbeb9f683f74" => :catalina
    sha256 "f858bea22c78dc5e807183ff23cda2d2af13b84e5d445702751214cf9a58b85b" => :mojave
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
