class Pcapmirror < Formula
  desc "Tool for capturing network traffic on remote host using TZSP or ERSPAN"
  homepage "https://git.freestone.net/cramer/pcapmirror"
  url "https://git.freestone.net/cramer/pcapmirror/-/archive/0.6.1/pcapmirror-0.6.1.tar.gz"
  sha256 "e8f147b6b73865d292d4aed2f9f2a376b25608b71b638146630b3397358c37cb"
  license "BSD-3-Clause"

  depends_on "make" => :build
  on_linux do
     depends_on "libpcap"
  end

  uses_from_macos "libpcap"

  def install
     bin.mkpath
     man8.mkpath
     system "make", "install"
  end

  test do
     assert_match(/Available network interfaces:/, shell_output("#{bin}/pcapmirror -l"))
  end
end
