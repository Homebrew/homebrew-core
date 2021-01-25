class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~sircmpwn/aerc/archive/0.5.2.tar.gz"
  sha256 "87b922440e53b99f260d2332996537decb452c838c774e9340b633296f9f68ee"
  license "MIT"

  bottle do
    sha256 "bfbdc6552a248e34e2a85f24664568a8bfc80a3941eb01bc05f9c9b97b6bc811" => :big_sur
    sha256 "a4639b3dd82342db1626a79c90b5275bafaa87a23c415b92fb24577a49c94f53" => :arm64_big_sur
    sha256 "52d1557638048defbd2c5dfc83ecd929acbbecbd3ee40a6dd8c2460a2232f81d" => :catalina
    sha256 "fe2c485199cdf423c32e27d69ebc5a2af2b355b6a8b2e24ff467a4fc23899b4d" => :mojave
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
