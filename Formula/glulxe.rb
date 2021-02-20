class Glulxe < Formula
  desc "Portable VM like the Z-machine"
  homepage "https://www.eblong.com/zarf/glulx/"
  url "https://eblong.com/zarf/glulx/glulxe-054.tar.gz"
  version "0.5.4"
  sha256 "1fc26f8aa31c880dbc7c396ede196c5d2cdff9bdefc6b192f320a96c5ef3376e"
  license "MIT"
  head "https://github.com/erkyrath/glulxe.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5d7b38cab2ce276b1757967e7f63a0fa20ab9ed0ba8e9deb18865e403862d144"
    sha256 cellar: :any_skip_relocation, big_sur:       "c91f5b0f903a0f4d94949e38aa9eecb5ec9102ad84ea498d890fd630a507334e"
    sha256 cellar: :any_skip_relocation, catalina:      "8f14cd2b19deb64a78d25bda3426d27b0fa25708daf39f7ccd9721daca81b8f1"
    sha256 cellar: :any_skip_relocation, mojave:        "cfff5a59e704d30bd2cd75955245c286183b301dc93bd63c8ba9e7e2d00c356f"
    sha256 cellar: :any_skip_relocation, high_sierra:   "229ef4b0b9e61f0e1ecf0b632ccd5fee08df494a97203820368e669a91f4028d"
    sha256 cellar: :any_skip_relocation, sierra:        "3a36753838342aef55319fdf1aab32666caffcb714fefd328a93521ed33d6adf"
    sha256 cellar: :any_skip_relocation, el_capitan:    "b5bc0c06241f2c7de3da21b27f2126903550fe959378992fe5260eeedb0f612f"
    sha256 cellar: :any_skip_relocation, yosemite:      "b50be16e36671d7818d123403937496f258882c98bbc6f4d8242c2e6eb97b310"
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
