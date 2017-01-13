class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "http://blockhash.io/"
  url "https://github.com/commonsmachinery/blockhash/archive/0.2.tar.gz"
  sha256 "485c356afc665ab26a33dfe2d6e67feb3dfc3ca610f7ea80bd28b121c42640ca"
  head "https://github.com/commonsmachinery/blockhash.git"

  bottle do
    cellar :any
    sha256 "87d5313dda961ce3c0bbda16d0aaa508293816bdd172a0732035fd95ca1c1060" => :sierra
    sha256 "bdd48d308fa431b8c3fb12124e09755754cfef0a49bc1d3e9c9cf39eef43b1b3" => :el_capitan
    sha256 "e87a82f9fb837b00945c2c58c336fe9299d4c3461e3514bce368e8440223252e" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "imagemagick"

  resource "testdata" do
    url "https://raw.githubusercontent.com/commonsmachinery/blockhash/ce08b465b658c4e886d49ec33361cee767f86db6/testdata/clipper_ship.jpg"
    sha256 "a9f6858876adadc83c8551b664632a9cf669c2aea4fec0c09d81171cc3b8a97f"
  end

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end

  test do
    resource("testdata").stage testpath
    hash = "00007ff07fe07fe07fe67ff07520600077fe601e7f5e000079fd40410001fffe"
    result = shell_output("#{bin}/blockhash #{testpath}/clipper_ship.jpg")
    assert_match hash, result
  end
end
