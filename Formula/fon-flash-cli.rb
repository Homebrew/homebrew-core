class FonFlashCli < Formula
  desc "Flash La Fonera and Atheros chipset compatible devices"
  homepage "https://www.gargoyle-router.com/wiki/doku.php?id=fon_flash"
  url "https://www.gargoyle-router.com/downloads/src/gargoyle_1.9.1-src.tar.gz"
  version "1.9.1"
  sha256 "02f3fd919079d3d085a82bc9f5c5f2b5687345df47c439601b2b2568043a0f1f"
  head "https://github.com/ericpaulbishop/gargoyle.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "20a4d83d686b4c8ac2ec4fa4e242f186b45682e4fe1878e75223c0687ad29919" => :el_capitan
    sha256 "5d452d1f7eaf65c8aa0e34321fc7c7f0d9831a30860b70349eefee3c17c17865" => :yosemite
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
