class Proxytunnel < Formula
  desc "Create TCP tunnels through HTTPS proxies"
  homepage "https://github.com/proxytunnel/proxytunnel"
  url "https://github.com/proxytunnel/proxytunnel/archive/v1.10.20200507.tar.gz"
  sha256 "6495430e9c60d3df53824a7a0f3bea9953a89d083a3718c72db04dc4d40755ac"

  bottle do
    cellar :any
    sha256 "f356990b424dc670a68c753c072e1a008d772bf7e27025f34b343c4a63a590d9" => :catalina
    sha256 "045219106e5c4b06627cf57fd21b27c8a24d11c5375df3c028e9b23d719e4b0f" => :mojave
    sha256 "98cf5abe9bbb285c92ef1c0e504968707fa5106e2783fed2dbfc64fb2a5dafd4" => :high_sierra
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
