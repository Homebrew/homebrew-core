class Proxytunnel < Formula
  desc "Create TCP tunnels through HTTPS proxies"
  homepage "https://github.com/proxytunnel/proxytunnel"
  url "https://github.com/proxytunnel/proxytunnel/archive/1.9.1.tar.gz"
  sha256 "4a68d2c33bf53c290346b0a76e2c3d25556e954ba346be68cf65ae8f73ae8007"
  revision 1

  bottle do
    cellar :any
    sha256 "3538bb076024d406670df496f8d40f5c9d17778f20964a0f9e97e35fac37ea8e" => :mojave
    sha256 "7963d82d5defc801687b5ec2b051c97ea2c765fd67ff784374421502159a4c7d" => :high_sierra
    sha256 "ce64fc5b482aed4ca7f1fc0c7bc3e1ebccae84dc50fb2659d6a560dca8cd7435" => :sierra
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
