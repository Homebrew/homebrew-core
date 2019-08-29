class Proxytunnel < Formula
  desc "Create TCP tunnels through HTTPS proxies"
  homepage "https://github.com/proxytunnel/proxytunnel"
  url "https://github.com/proxytunnel/proxytunnel/archive/1.9.1.tar.gz"
  sha256 "4a68d2c33bf53c290346b0a76e2c3d25556e954ba346be68cf65ae8f73ae8007"

  bottle do
    cellar :any
    sha256 "314fb0fca0c00e2ae02be5bd4cf5c78eda383d554a7e9f85bfc8b2356463ad2e" => :mojave
    sha256 "2b609ba5cca3c9c646b22853402bac1b3c86377301616bd37543a5e81b4dc2fa" => :high_sierra
    sha256 "d57947d51d68cecf55d6180d3561b30d31f6bf9e9f370e60261ab96bf9088677" => :sierra
    sha256 "2bb3a40e31c0bb0173a869ef5045ba80941ef78ce80bfe9f1d200993aae46a5d" => :el_capitan
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "openssl" # no OpenSSL 1.1 support

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

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/proxytunnel", "--version"
  end
end
