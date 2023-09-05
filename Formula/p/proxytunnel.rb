class Proxytunnel < Formula
  desc "Create TCP tunnels through HTTPS proxies"
  homepage "https://github.com/proxytunnel/proxytunnel"
  url "https://github.com/proxytunnel/proxytunnel/archive/v1.11.tar.gz"
  sha256 "edc820c9ea48e0a37f231a40f77eb83b9c3f26ebc31bf4e6f8ee3cd090cbebf2"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "07bb36a07ae75f71bfe246d5bb5b1232a8baad865e37c167de15b0aa98002b54"
    sha256 cellar: :any,                 arm64_monterey: "0f97697c9115a10b5e570f5d81919b7b5fdea36d8ba569d409ae9dfd3187b5a1"
    sha256 cellar: :any,                 arm64_big_sur:  "d9df09429d4d52fb92cdd3b6ef2072abaacaf6370fb2361139e94e83cf8173c6"
    sha256 cellar: :any,                 ventura:        "381b822242673289f29312b4f98bf4ff8c7c9a59607b8f4635dc1d452c5b958e"
    sha256 cellar: :any,                 monterey:       "a1e106e210f10226c6685e600f2938b059ded79b619efebc35846477eaf7745a"
    sha256 cellar: :any,                 big_sur:        "d713f28c6e1620c749ecc47ac9a711ace29160299a4fcda1dd2a833166eb1658"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d2bb4d98ac2247f3e659d1ceb9aa4cbcc98a0e523f71181c8917ef290b196aa"
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
