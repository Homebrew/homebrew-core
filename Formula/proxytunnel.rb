class Proxytunnel < Formula
  desc "Create TCP tunnels through HTTPS proxies"
  homepage "https://github.com/proxytunnel/proxytunnel"
  url "https://github.com/proxytunnel/proxytunnel/archive/1.9.1.tar.gz"
  sha256 "4a68d2c33bf53c290346b0a76e2c3d25556e954ba346be68cf65ae8f73ae8007"

  bottle do
    cellar :any
    sha256 "3d21252f1f5467a072fbdfff215d30e104a97510061a06a3b84f2ecbf3ee527b" => :high_sierra
    sha256 "713f4529f60bc07a7ffc751730907b7f8238395a93a33d2430e272b66aab057a" => :sierra
    sha256 "6632b143edd3bbe2f8620bec9445e78689193d05279f1bb13766d16168bf871f" => :el_capitan
    sha256 "6764d4c9ce6bd4fcf08e7b8042a93977cb5788d316b54552bc6f49348a032c09" => :yosemite
    sha256 "7a0c91840116c8a6cdc492d671f0426dbd1adcf8b20e1d7259ea3c42a3eb1d6f" => :mavericks
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "openssl"

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
