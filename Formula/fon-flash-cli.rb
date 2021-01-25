class FonFlashCli < Formula
  desc "Flash La Fonera and Atheros chipset compatible devices"
  homepage "https://www.gargoyle-router.com/wiki/doku.php?id=fon_flash"
  url "https://www.gargoyle-router.com/downloads/src/gargoyle_1.12.0-src.tar.gz"
  version "1.12.0"
  sha256 "722520cb6774f011dccf80d6d91893de608b76ebf12372cfdd5d004d99a4012a"
  license "GPL-2.0"
  head "https://github.com/ericpaulbishop/gargoyle.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "90b2a5aaa862a0caf59d54b9360e6c4ce247a6348ee578c2152ffe7859c46462" => :big_sur
    sha256 "c6640a91909961082cfe444d7d10a53dee5ebf69355f6f1c37470957a9ccaee9" => :arm64_big_sur
    sha256 "3e37b716229888d09999e4abcb432d0d9b4e604345dbc824cb032e7840fad793" => :catalina
    sha256 "6d8285e23b9ab3563c43ffa9d02c99dc3506a29a07174b7ff2ed7f709bbd7117" => :mojave
    sha256 "f60605913533cdc90c6ef163efc7b112af2a61f606b53a715639e08288838dbf" => :high_sierra
  end

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
