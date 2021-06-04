class Proxytunnel < Formula
  desc "Create TCP tunnels through HTTPS proxies"
  homepage "https://github.com/proxytunnel/proxytunnel"
  url "https://github.com/proxytunnel/proxytunnel/archive/v1.10.20210604.tar.gz"
  sha256 "47b7ef7acd36881744db233837e7e6be3ad38e45dc49d2488934882fa2c591c3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "222f0244f92ca6e2ce051db0da342cd72ae5072a69757a92c20c0423fa017e02"
    sha256 cellar: :any, big_sur:       "5e8d043da430d8ecc266bf8411e29832f84e0aaa753eec116448826d74f356ce"
    sha256 cellar: :any, catalina:      "f8aa1e88ac9c787e87bdfb82f4d20af89d86cb3f1cbc479b14efa09e5edcd97f"
    sha256 cellar: :any, mojave:        "4583ebc48440fc29779b781490b598ae5acc09e9fcc00752284a26cd831c5e01"
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "openssl@1.1"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/proxytunnel", "--version"
  end
end
