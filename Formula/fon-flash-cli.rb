class FonFlashCli < Formula
  desc "Flash La Fonera and Atheros chipset compatible devices"
  homepage "https://www.gargoyle-router.com/wiki/doku.php?id=fon_flash"
  url "https://www.gargoyle-router.com/downloads/src/gargoyle_1.9.2-src.tar.gz"
  version "1.9.2"
  sha256 "3b6fa0c1e1e167922fb7b8824789e5207c19136a5f2585b7309335379e4c3b16"
  head "https://github.com/ericpaulbishop/gargoyle.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef0b11fe14338a9250028b66a170cbffd12e6c51f09e990ff601016cff11f736" => :sierra
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
