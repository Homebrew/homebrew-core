class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "http://blockhash.io/"
  url "https://github.com/commonsmachinery/blockhash/archive/0.2.1.tar.gz"
  sha256 "549e0f52e7a7545bae7eca801c64c79b95cbe9417975718e262fddaf78b00cca"
  revision 2
  head "https://github.com/commonsmachinery/blockhash.git"

  bottle do
    cellar :any
    sha256 "a55403e6c23a73a46c8b320fc4a14386be03293f0935fddf05bc8a910d0257aa" => :sierra
    sha256 "ada61986c03a4ea6b50aad241906bf4946c5ff0eac69def8e66c3bdb4f1a23bd" => :el_capitan
    sha256 "f7209a7c71a24b0d78b64f85bb47e775f0ae181c59ed6567afe2dfdbcd77f4c0" => :yosemite
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
