class Otf2bdf < Formula
  desc "OpenType to BDF font converter"
  homepage "http://sofia.nmsu.edu/~mleisher/Software/otf2bdf/"
  url "http://sofia.nmsu.edu/~mleisher/Software/otf2bdf/otf2bdf-3.1.tbz2"
  sha256 "3d63892e81187d5192edb96c0dc6efca2e59577f00e461c28503006681aa5a83"

  bottle do
    cellar :any
    rebuild 1
    sha256 "200d4f317f5fda0c3c4a350ba773322af4a29af56a65f9e3de11b406ab517522" => :catalina
    sha256 "76e89f43b017f0bc2f90c3d49e70d75ac9da5260b9567d1078449f1b80af60bf" => :mojave
    sha256 "208ef317e3c51e88818c4f59ca0333a76d6efeed97b04affe66c3cd6b601bada" => :high_sierra
  end

  depends_on "freetype"

  resource "mkinstalldirs" do
    url "http://sofia.nmsu.edu/~mleisher/Software/otf2bdf/mkinstalldirs"
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
