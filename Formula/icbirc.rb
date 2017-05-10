class Icbirc < Formula
  desc "Proxy IRC client and ICB server"
  homepage "https://www.benzedrine.ch/icbirc.html"
  url "https://www.benzedrine.ch/icbirc-2.0.tar.gz"
  sha256 "7607c7d80fc3939ccb913c9fcc57a63d3552af3615454e406ff0e3737c0ce6bd"

  bottle do
    cellar :any_skip_relocation
    sha256 "85d7afcdfe8009b68a697a0fdea24dfda0cda6cc65dfae9f99fae7a1d1fb0ea8" => :sierra
    sha256 "3d9cf7664d20818b648258da1c52cb397c0324d852eca445d62a8d3f2543fc3c" => :el_capitan
    sha256 "08fa7b7435d429c8c21ff2d7835d0b7341fa3dd7cc5677241d1a897ec47cc883" => :yosemite
    sha256 "d16b5155b2f117cdc442eef09114ecffe180ecaf3c67e3c501374ba6e03a144a" => :mavericks
    sha256 "fec513444c71ecef76d4b5650749f2a18cbfb16dc6cf35894ddd46b0096c248b" => :mountain_lion
  end

  depends_on "bsdmake" => :build

  def install
    system "bsdmake"
    bin.install "icbirc"
    man8.install "icbirc.8"
  end
end
