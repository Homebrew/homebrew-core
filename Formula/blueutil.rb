class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/v2.6.0.tar.gz"
  sha256 "5ba90cdedd886566e1304813891c0f9f6139db67aaf2829a8294973ee3d0b66c"
  head "https://github.com/toy/blueutil.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e82b1bcb5a3737fb75474f4f1e793f1954d6cc2ebf8cde4c538efc046998dbf" => :catalina
    sha256 "151d723172aaf7acd9b23cf2a0b41f0fe5100357f511fea170cf34bc05093bb5" => :mojave
    sha256 "afceca3182b5a43540b44c2b61bb0d510888f0744e924468ee3208d8ab612a4a" => :high_sierra
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
