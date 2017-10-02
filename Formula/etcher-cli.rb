class EtcherCli < Formula
  desc "Flash OS images to SD cards & USB drives, safely and easily."
  homepage "https://etcher.io"
  url "https://github.com/resin-io/etcher/releases/download/v1.1.2/Etcher-cli-1.1.2-darwin-x64.tar.gz"
  sha256 "3fd81af71fa3c6b8d8d07a7ca2895219de62b23057182b3d33c95de1e5499644"
  version "1.1.2"
  
  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "false"
  end
end

