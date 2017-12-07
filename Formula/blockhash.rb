class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "https://github.com/commonsmachinery/blockhash"
  url "https://github.com/commonsmachinery/blockhash/archive/v0.3.tar.gz"
  sha256 "a4fbe16dc8d1e9b82de860d97222ce6259495f7832c7dfe3de9e0bb42f85995e"
  revision 1
  head "https://github.com/commonsmachinery/blockhash.git"

  bottle do
    cellar :any
    sha256 "d93acc3ec087d317d7e0fbe166d83745f516d2f85d32c3acc8fa0a18b764853c" => :high_sierra
    sha256 "e4cce87334c21ede18f40f74ccb2f00a9d298e3b4f4e46b4aaedeefe0341e95e" => :sierra
    sha256 "41faab24b6b7e72dff9719972dd7c2fc16864c2b99a69aa5d6250816b27aa2e3" => :el_capitan
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
