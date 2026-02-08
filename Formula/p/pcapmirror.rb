class Pcapmirror < Formula
  desc "Tool for capturing network traffic on remote host using TZSP or ERSPAN"
  homepage "https://git.freestone.net/cramer/pcapmirror"
  url "https://git.freestone.net/cramer/pcapmirror/-/archive/0.6/pcapmirror-0.6.tar.gz"
  sha256 "8e8e8a0030f60a7324b0616c96b8d1e455f2e05c208247eac10303dffacff086"
  license "BSD-3-Clause"

  depends_on "make" => :build
  depends_on "libpcap"

  def install
    system "make"
    bin.install "pcapmirror"
    man.install "pcapmirror.8"
  end

  test do
    system bin/"pcapmirror", "-h"
  end
end
