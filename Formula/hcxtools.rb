class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/6.0.2.tar.gz"
  sha256 "963029bf00d3a98f2caa934d5765a91e29f5d1b0e0036a4c53328b5cf9c3c003"
  head "https://github.com/ZerBea/hcxtools.git"

  depends_on "openssl@1.1"

  def install
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl@1.1"].opt_include}"
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@1.1"].opt_lib}"

    system "make"

    bin.install "hcxessidtool",
      "hcxhash2cap",
      "hcxhashcattool",
      "hcxhashtool",
      "hcxmactool",
      "hcxpcapngtool",
      "hcxpcaptool",
      "hcxpmkidtool",
      "hcxpsktool",
      "hcxwltool",
      "whoismac",
      "wlancap2wpasec",
      "wlanhcx2john",
      "wlanhcx2ssid",
      "wlanhcxcat",
      "wlanhcxinfo",
      "wlanjohn2hcx",
      "wlanpmk2hcx",
      "wlanwkp2hcx"
  end

  test do
    system "#{bin}/hcxpcapngtool", "--version"
  end
end
