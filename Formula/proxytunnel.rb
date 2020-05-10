class Proxytunnel < Formula
  desc "Create TCP tunnels through HTTPS proxies"
  homepage "https://github.com/proxytunnel/proxytunnel"
  url "https://github.com/proxytunnel/proxytunnel/archive/v1.10.20200507.tar.gz"
  sha256 "6495430e9c60d3df53824a7a0f3bea9953a89d083a3718c72db04dc4d40755ac"

  bottle do
    cellar :any
    sha256 "37f2fa40f5470d1af77b0290d0365677f926e995ddf97fb706c70cb0d362958d" => :catalina
    sha256 "3538bb076024d406670df496f8d40f5c9d17778f20964a0f9e97e35fac37ea8e" => :mojave
    sha256 "7963d82d5defc801687b5ec2b051c97ea2c765fd67ff784374421502159a4c7d" => :high_sierra
    sha256 "ce64fc5b482aed4ca7f1fc0c7bc3e1ebccae84dc50fb2659d6a560dca8cd7435" => :sierra
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
