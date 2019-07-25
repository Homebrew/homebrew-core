class Moe < Formula
  desc "Console text editor for ISO-8859 and ASCII"
  homepage "https://www.gnu.org/software/moe/moe.html"
  url "https://ftp.gnu.org/gnu/moe/moe-1.10.tar.lz"
  mirror "https://ftpmirror.gnu.org/moe/moe-1.10.tar.lz"
  sha256 "8cfd44ab5623ed4185ee53962b879fd9bdd18eab47bf5dd9bdb8271f1bf7d53b"

  bottle do
    rebuild 1
    sha256 "b1b91b2a30d506381f31c96f63e75bc78e32bec6051dd2e62d78fa19775975b8" => :mojave
    sha256 "8795bf38abe1ee929d3573e25bd54bb73220d4d2b30d0f2af4b6242ae5f862f7" => :high_sierra
    sha256 "c5015c950c74f73093aacac9e9f3b42f741b5bc57e864006c2a62f3c6739c538" => :sierra
    sha256 "4b7e08c089bcf431efba6be217df5a30e7ade7fa2813ae53152e5671958abb69" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/moe", "--version"
  end
end
