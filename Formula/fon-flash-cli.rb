class FonFlashCli < Formula
  desc "Flash La Fonera and Atheros chipset compatible devices"
  homepage "https://www.gargoyle-router.com/wiki/doku.php?id=fon_flash"
  url "https://github.com/ericpaulbishop/gargoyle/archive/1.13.0.tar.gz"
  sha256 "8086c5c0725f520b659eecca5784a9f0f25eb8eac0deafc967f0264977b3fbe1"
  license "GPL-2.0-or-later"
  head "https://github.com/ericpaulbishop/gargoyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c6640a91909961082cfe444d7d10a53dee5ebf69355f6f1c37470957a9ccaee9"
    sha256 cellar: :any_skip_relocation, big_sur:       "90b2a5aaa862a0caf59d54b9360e6c4ce247a6348ee578c2152ffe7859c46462"
    sha256 cellar: :any_skip_relocation, catalina:      "3e37b716229888d09999e4abcb432d0d9b4e604345dbc824cb032e7840fad793"
    sha256 cellar: :any_skip_relocation, mojave:        "6d8285e23b9ab3563c43ffa9d02c99dc3506a29a07174b7ff2ed7f709bbd7117"
    sha256 cellar: :any_skip_relocation, high_sierra:   "f60605913533cdc90c6ef163efc7b112af2a61f606b53a715639e08288838dbf"
  end

  uses_from_macos "libpcap"

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
