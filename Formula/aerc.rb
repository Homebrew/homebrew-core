class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~sircmpwn/aerc/archive/0.5.2.tar.gz"
  sha256 "dec6560c1359d1d56124a85692e877e319036f0312ce9b7a31f9828f99b92c61"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "a4639b3dd82342db1626a79c90b5275bafaa87a23c415b92fb24577a49c94f53"
    sha256 big_sur:       "bfbdc6552a248e34e2a85f24664568a8bfc80a3941eb01bc05f9c9b97b6bc811"
    sha256 catalina:      "52d1557638048defbd2c5dfc83ecd929acbbecbd3ee40a6dd8c2460a2232f81d"
    sha256 mojave:        "fe2c485199cdf423c32e27d69ebc5a2af2b355b6a8b2e24ff467a4fc23899b4d"
    sha256 x86_64_linux:  "fec7ba00c4eab6ae87ea98bad514b50d43c06189e8eece0f63beaa3487d84ab7"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/aerc", "-v"
  end
end
