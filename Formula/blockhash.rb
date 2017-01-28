class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "http://blockhash.io/"
  url "https://github.com/commonsmachinery/blockhash/archive/0.2.1.tar.gz"
  sha256 "549e0f52e7a7545bae7eca801c64c79b95cbe9417975718e262fddaf78b00cca"
  head "https://github.com/commonsmachinery/blockhash.git"
  revision 1

  bottle do
    cellar :any
    sha256 "0661976a66ec05343748ceeea27ad2ea972e645834f56cac0780bcf0f9dce98b" => :sierra
    sha256 "a12285fd189dc73cb3ad302f52dd3f025c2992c59bac8f5f00841b17fa36e7b7" => :el_capitan
    sha256 "a2c96447f15119a973d35a95b5fde7a802eeaf0d114f6bfbce4dde9243382db2" => :yosemite
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
