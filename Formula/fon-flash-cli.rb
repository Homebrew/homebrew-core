class FonFlashCli < Formula
  desc "Flash La Fonera and Atheros chipset compatible devices"
  homepage "https://www.gargoyle-router.com/wiki/doku.php?id=fon_flash"
  url "https://www.gargoyle-router.com/downloads/src/gargoyle_1.9.2-src.tar.gz"
  version "1.9.2"
  sha256 "3b6fa0c1e1e167922fb7b8824789e5207c19136a5f2585b7309335379e4c3b16"
  head "https://github.com/ericpaulbishop/gargoyle.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "138e6500d0bf07eeb85884c0262fd7186a129860f7c07e4094bacf7fdc4aa520" => :sierra
    sha256 "f649d0082338f4d47d88bf75c9d5204b715333a1752aef2856863eb0e47bd263" => :el_capitan
    sha256 "03376ba51c845363e3900851fe5485bb6ba184b127bc619a0d70b7401b112df6" => :yosemite
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
