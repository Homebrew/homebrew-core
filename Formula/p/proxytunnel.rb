class Proxytunnel < Formula
  desc "Create TCP tunnels through HTTPS proxies"
  homepage "https://github.com/proxytunnel/proxytunnel"
  url "https://github.com/proxytunnel/proxytunnel/archive/v1.11.1.tar.gz"
  sha256 "d95e4974d37cc96ea5d9906ea7808db4560981902a40217368877409145ada96"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5733eb2b124b5188da6f359f1040761312637da98c9ff1f364204622c5d99497"
    sha256 cellar: :any,                 arm64_ventura:  "e9b9edb440e59365eb9f28849ba7f7596cbfc6d02c94293f3552136312237838"
    sha256 cellar: :any,                 arm64_monterey: "129f062d4c2e1860dc09c61181603ab3ff9031651ceeb05971721d7744aa7915"
    sha256 cellar: :any,                 sonoma:         "9128f2685fccf86ba72e474e045f15b9811ec924d6ef8766b491642105e3d8ec"
    sha256 cellar: :any,                 ventura:        "998a3287bc3817a0a6b333d0a07467f22a56a07d2c574c101922abce134f66dd"
    sha256 cellar: :any,                 monterey:       "279dcb4a92da61f3c556b9e32a36f637b8f873d3d200cf745c917129948db839"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6caa54d83fc3db5808d05c1139158c29136b5fd08dc551b792e28a5b07360673"
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
