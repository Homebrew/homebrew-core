class Proxytunnel < Formula
  desc "Create TCP tunnels through HTTPS proxies"
  homepage "https://github.com/proxytunnel/proxytunnel"
  url "https://github.com/proxytunnel/proxytunnel/archive/1.9.1.tar.gz"
  sha256 "4a68d2c33bf53c290346b0a76e2c3d25556e954ba346be68cf65ae8f73ae8007"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "83e2a7fb8b5f2d19c78bc191f1ecc9169eb69313302e721878d73a5c9a4cc5d7" => :mojave
    sha256 "563b5870aa7d2019c192482f5bee1616a067bdcc616f32ea342065fa9bcd38c1" => :high_sierra
    sha256 "f49a10d7a8d48e8c7b0d6f6e75c8999c8161405c28564fc6d9d2d03c75882dc5" => :sierra
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "openssl@1.1"

  # Remove for > 1.9.1
  # Remove conflicting strlcpy/strlcat declarations
  # Upstream commit 8 Nov 2016 "Make building on OSX work out of the box"
  patch do
    url "https://github.com/proxytunnel/proxytunnel/commit/0cfce96.patch?full_index=1"
    sha256 "9d1341860cebfed4851896f657bf8d204dc3efdc57f973f969ca1782b55e2fe3"
  end

  # Fix "install: illegal option -- D"
  # Upstream PR from 14 May 2018 "Makefile: don't use non-portable -D option"
  patch do
    url "https://github.com/proxytunnel/proxytunnel/pull/27.patch?full_index=1"
    sha256 "981737b32526b7ff9520236175ac36831d23d71195275f68f444c3832c5db8ab"
  end

  # Upstream commit for OpenSSL 1.1 compatibility
  patch do
    url "https://github.com/proxytunnel/proxytunnel/commit/2a26224b.diff?full_index=1"
    sha256 "53fa9fc73c88a1ee157c0d47cb93f4199ec89ce2636bd61ca7706f2a3d30ffed"
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/proxytunnel", "--version"
  end
end
