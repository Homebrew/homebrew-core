class Lilv < Formula
  desc "C library to use LV2 plugins"
  homepage "https://drobilla.net/software/lilv.html"
  url "https://download.drobilla.net/lilv-0.24.12.tar.bz2"
  sha256 "26a37790890c9c1f838203b47f5b2320334fe92c02a4d26ebbe2669dbd769061"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?lilv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "208e40032fffa5c584cab440cc7cd1e5abcde9cef28c0040a2415aa953141ecc"
    sha256 cellar: :any, arm64_big_sur:  "7d5c20eca54b3c37a221850a1dee80db09936951a68b809ac273b818520742e5"
    sha256 cellar: :any, monterey:       "c6537e52e89e1866ba927552da7e4ca9bb2be04749c1f0ce9e8ae109c0962d5b"
    sha256 cellar: :any, big_sur:        "0bd83420cebc6262ce2c99f52dc4a0e1b292eb4fb1a5342eede0a0de42042f9d"
    sha256 cellar: :any, catalina:       "209a76fdfb98e2ed7c4fb0c61a30f74f6d20d733bdfa4119f3508a4b4e7b2670"
    sha256 cellar: :any, mojave:         "59935741b27150d9c72f5c0d436c4d2df1e932d4edb3f6f75d3ab68b50ec42ca"
  end

  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"
  depends_on "sratom"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end
