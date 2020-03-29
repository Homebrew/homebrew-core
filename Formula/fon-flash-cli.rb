class FonFlashCli < Formula
  desc "Flash La Fonera and Atheros chipset compatible devices"
  homepage "https://www.gargoyle-router.com/wiki/doku.php?id=fon_flash"
  url "https://www.gargoyle-router.com/downloads/src/gargoyle_1.12.0-src.tar.gz"
  version "1.12.0"
  sha256 "722520cb6774f011dccf80d6d91893de608b76ebf12372cfdd5d004d99a4012a"
  head "https://github.com/ericpaulbishop/gargoyle.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e37b716229888d09999e4abcb432d0d9b4e604345dbc824cb032e7840fad793" => :catalina
    sha256 "6d8285e23b9ab3563c43ffa9d02c99dc3506a29a07174b7ff2ed7f709bbd7117" => :mojave
    sha256 "f60605913533cdc90c6ef163efc7b112af2a61f606b53a715639e08288838dbf" => :high_sierra
  end

  # requires at least the 10.11 SDK
  depends_on :macos => :yosemite

  def install
    cd "fon-flash" do
      system "make", "fon-flash"
      bin.install "fon-flash"
    end
  end

  test do
    system "#{bin}/fon-flash"
  end
end
