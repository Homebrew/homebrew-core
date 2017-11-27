class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "https://github.com/commonsmachinery/blockhash"
  url "https://github.com/commonsmachinery/blockhash/archive/v0.3.tar.gz"
  sha256 "a4fbe16dc8d1e9b82de860d97222ce6259495f7832c7dfe3de9e0bb42f85995e"
  head "https://github.com/commonsmachinery/blockhash.git"

  bottle do
    cellar :any
    sha256 "293664ab10135fca1a4cd16c5f429b080725370eba7e3bb4a7197397baf61b7b" => :high_sierra
    sha256 "ad5041dd82571cda1572111c458f3119f87d5fd76f73ed183a06b5f9819785e4" => :sierra
    sha256 "404542e114e192e4666946b6811e0c8c49369fe7ef0d885c572fafd3ba695534" => :el_capitan
    sha256 "b00df389c1d5b91b13d1908bd9e1f491bd774799892799f5242388052ea7288f" => :yosemite
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
    hash = "00007ff07ff07fe07fe67ff07560600077fe701e7f5e000079fd40410001ffff"
    result = shell_output("#{bin}/blockhash #{testpath}/clipper_ship.jpg")
    assert_match hash, result
  end
end
