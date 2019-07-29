class Glulxe < Formula
  desc "Portable VM like the Z-machine"
  homepage "https://www.eblong.com/zarf/glulx/"
  url "https://eblong.com/zarf/glulx/glulxe-054.tar.gz"
  version "0.5.4"
  sha256 "1fc26f8aa31c880dbc7c396ede196c5d2cdff9bdefc6b192f320a96c5ef3376e"
  head "https://github.com/erkyrath/glulxe.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cfff5a59e704d30bd2cd75955245c286183b301dc93bd63c8ba9e7e2d00c356f" => :mojave
    sha256 "229ef4b0b9e61f0e1ecf0b632ccd5fee08df494a97203820368e669a91f4028d" => :high_sierra
    sha256 "3a36753838342aef55319fdf1aab32666caffcb714fefd328a93521ed33d6adf" => :sierra
    sha256 "b5bc0c06241f2c7de3da21b27f2126903550fe959378992fe5260eeedb0f612f" => :el_capitan
    sha256 "b50be16e36671d7818d123403937496f258882c98bbc6f4d8242c2e6eb97b310" => :yosemite
  end

  depends_on "glktermw" => :build

  def install
    glk = Formula["glktermw"]
    inreplace "Makefile", "GLKINCLUDEDIR = ../cheapglk", "GLKINCLUDEDIR = #{glk.include}"
    inreplace "Makefile", "GLKLIBDIR = ../cheapglk", "GLKLIBDIR = #{glk.lib}"
    inreplace "Makefile", "Make.cheapglk", "Make.#{glk.name}"

    system "make"
    bin.install "glulxe"
  end

  test do
    assert pipe_output("#{bin}/glulxe -v").start_with? "GlkTerm, library version"
  end
end
