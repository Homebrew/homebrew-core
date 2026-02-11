class Pcapmirror < Formula
  desc "Tool for capturing network traffic on remote host using TZSP or ERSPAN"
  homepage "https://git.freestone.net/cramer/pcapmirror"
  url "https://git.freestone.net/cramer/pcapmirror/-/archive/0.6.1/pcapmirror-0.6.1.tar.gz"
  sha256 "61eab2ebf07101fedd56af5d6d34c9aedb3d0564c8f4c5fcdca3aee966753abf"
  license "BSD-3-Clause"

  depends_on "make" => :build
  uses_from_macos "libpcap"

  on_linux do
     depends_on "libpcap"
  end

  def install
     bin.mkpath
     man8.mkpath
     system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man}"
  end

  test do
     assert_match(/Available network interfaces:/, shell_output("#{bin}/pcapmirror -l"))
  end
end
