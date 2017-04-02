class Otf2bdf < Formula
  desc "OpenType to BDF font converter"
  homepage "https://www.math.nmsu.edu/~mleisher/Software/otf2bdf/"
  url "https://www.math.nmsu.edu/~mleisher/Software/otf2bdf/otf2bdf-3.1.tbz2"
  sha256 "3d63892e81187d5192edb96c0dc6efca2e59577f00e461c28503006681aa5a83"

  bottle do
    cellar :any
    sha256 "1bc1ef42c5ffaf8faf3e5f6e58e8678d9992d5bc5ea4ed607bf6c71f35dc6165" => :sierra
    sha256 "018d348c6fb0b0a413c85bd575d93837f4bb03c654243f1c6ce9d54e417d77e9" => :el_capitan
    sha256 "751f5243a8be995963d1b4e20bea3d52823fdcbadb727d0eab20e6715277db40" => :yosemite
    sha256 "70fb9d592eaa1cbc1f3e2a448c023988ea5e86035633d387c959de8c725a98f8" => :mavericks
  end

  depends_on "freetype"

  resource "mkinstalldirs" do
    url "https://www.math.nmsu.edu/~mleisher/Software/otf2bdf/mkinstalldirs"
    sha256 "e7b13759bd5caac0976facbd1672312fe624dd172bbfd989ffcc5918ab21bfc1"
  end

  def install
    buildpath.install resource("mkinstalldirs")
    chmod 0755, "mkinstalldirs"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    assert_match /MacRoman/, shell_output("#{bin}/otf2bdf -et /System/Library/Fonts/LucidaGrande.ttc")
  end
end
