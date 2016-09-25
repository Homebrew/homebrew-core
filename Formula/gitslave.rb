class Gitslave < Formula
  desc "Create group of related repos with one as superproject"
  homepage "http://gitslave.sourceforge.net"
  url "https://downloads.sourceforge.net/project/gitslave/gitslave-2.0.2.tar.gz"
  sha256 "8aa3dcb1b50418cc9cee9bee86bb4b279c1c5a34b7adc846697205057d4826f0"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ccd021a4393d137eed5c0dfdfe94b325b6142258a7090ad04f9166039efa52d" => :sierra
    sha256 "e556bf6f7ddfa3e9f6a9b726d80a35404270c96e36ada122fd16d8946394aaa6" => :el_capitan
    sha256 "395794a75f26acdf034f4ab1541cd9af327d13309517e2553bbcb1fdb4bb0f85" => :yosemite
    sha256 "f960d16d68868685850464321b5e4f82be4b85b1e3baa9392f185773818e596f" => :mavericks
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
