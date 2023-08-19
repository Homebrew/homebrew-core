class Proxytunnel < Formula
  desc "Create TCP tunnels through HTTPS proxies"
  homepage "https://github.com/proxytunnel/proxytunnel"
  url "https://github.com/proxytunnel/proxytunnel/archive/v1.10.20210604.tar.gz"
  sha256 "47b7ef7acd36881744db233837e7e6be3ad38e45dc49d2488934882fa2c591c3"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "aea82fc349cca9b1344170dc58e3152a8f4f24872a8a4cbac600a880cf4f3abb"
    sha256 cellar: :any,                 arm64_monterey: "d8a8d893b78c19ce75e2cd68a50b2a90d4f73516e31e73ba601e4ab61159583d"
    sha256 cellar: :any,                 arm64_big_sur:  "fd5dee02539fd006e3a8e4cdca443131c2a82ee8d4887b753341216f089cb6f5"
    sha256 cellar: :any,                 ventura:        "0b4b6fc0be9083c224ab5eacb7c5721ff752a7c293e2e84a7e0b256119eb0493"
    sha256 cellar: :any,                 monterey:       "de0910229cedf933e6f1090bdf1fc2f6913fe8526416c383ff0a255b6e820549"
    sha256 cellar: :any,                 big_sur:        "8a87e452920de367641fa92294fed758b62a71e174cbaaa9320edfc7d5b096b3"
    sha256 cellar: :any,                 catalina:       "8e9ef140d976394e926c488f5c33b0fd342e9669dda178c974f917d00440f1cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8208da2d960f5a7a61e9db2ee8b52f14c2770dccc927bb42032c29b198d64804"
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "openssl@3"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/proxytunnel", "--version"
  end
end
