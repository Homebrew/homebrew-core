class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/6.0.2.tar.gz"
  sha256 "963029bf00d3a98f2caa934d5765a91e29f5d1b0e0036a4c53328b5cf9c3c003"
  head "https://github.com/ZerBea/hcxtools.git"

  depends_on "openssl@1.1"

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/hcxpcapngtool", "--version"
  end
end
