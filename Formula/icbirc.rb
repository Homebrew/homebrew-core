class Icbirc < Formula
  desc "Proxy IRC client and ICB server"
  homepage "https://www.benzedrine.ch/icbirc.html"
  url "https://www.benzedrine.ch/icbirc-2.1.tar.gz"
  sha256 "6839344d93c004da97ec6bb5d805a1db7e0a79efc3870445788043627162bbb1"

  bottle do
    cellar :any_skip_relocation
    sha256 "c353062cf16183b658ca999e477f2f4ac6040dd8d3a995fe2736a382d989ca8e" => :mojave
    sha256 "e258e2ca2bf835d76b7d509eac5417629451068c85fe729cbab7fc64e89df9c0" => :high_sierra
    sha256 "cbec4e472c640a63081f12723fc9d144f00aa00c9229ce5bfc2edd99199aee74" => :sierra
    sha256 "2f943e4af7a9c1e2524d9583b0ef5539988f68f56a8f8c483b2c2d1990fff21d" => :el_capitan
    sha256 "c4fdfe55febee01d5fc84bdc7bb49ad6bb2366f6f5a54dfbb851ee891a67c5a3" => :yosemite
  end

  depends_on "bsdmake" => :build

  def install
    system "bsdmake"
    bin.install "icbirc"
    man8.install "icbirc.8"
  end
end
