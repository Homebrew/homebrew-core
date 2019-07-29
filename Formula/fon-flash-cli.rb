class FonFlashCli < Formula
  desc "Flash La Fonera and Atheros chipset compatible devices"
  homepage "https://www.gargoyle-router.com/wiki/doku.php?id=fon_flash"
  url "https://www.gargoyle-router.com/downloads/src/gargoyle_1.10.0-src.tar.gz"
  version "1.10.0"
  sha256 "6397505b4a0c1f65c4823314d73fe6ad71f8c860d4582c581f47f16615597245"
  head "https://github.com/ericpaulbishop/gargoyle.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "168f12dbfc3d6b58a094389b31e744267166fa5e1cf682970e6342c6c65d7b3e" => :mojave
    sha256 "eefb911151deebc71f57de54004b2d8622223b60c8bf6313fcf94a4309c7ce9a" => :high_sierra
    sha256 "9aa03dd80f5796ef9087b1e109660fa2c9dc612d399e24c5d61905934d087ac8" => :sierra
    sha256 "c612973622cb2b87b5043fecd3aa3419bfc75d469dd7c470e25b72a2d346b834" => :el_capitan
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
