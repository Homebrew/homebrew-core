class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/v2.7.0.tar.gz"
  sha256 "1b171abdadb008cc7f3dac6e647c000d4ae89246c27a8b2926e56643deb1e422"
  license "MIT"
  head "https://github.com/toy/blueutil.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6a34cffc707320bff30528653b12df4d0d6b708c6462865923b3ea52e4b9e5c" => :big_sur
    sha256 "9e82b1bcb5a3737fb75474f4f1e793f1954d6cc2ebf8cde4c538efc046998dbf" => :catalina
    sha256 "151d723172aaf7acd9b23cf2a0b41f0fe5100357f511fea170cf34bc05093bb5" => :mojave
    sha256 "afceca3182b5a43540b44c2b61bb0d510888f0744e924468ee3208d8ab612a4a" => :high_sierra
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
