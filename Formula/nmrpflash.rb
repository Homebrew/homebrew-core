class Nmrpflash < Formula
  desc "Netgear Unbrick Utility"
  homepage "https://github.com/jclehner/nmrpflash"
  url "https://github.com/jclehner/nmrpflash/archive/refs/tags/v0.9.18.tar.gz"
  sha256 "e1bc46445ab302d76fc4d9a99885f5df404b77a7c836bf2ef9f08fd73390db38"
  license "GPL-3.0-or-later"

  uses_from_macos "libpcap"

  # for now
  depends_on :macos

  def install
    system "make", "VERSION=#{version}"
    # "make install" is currently broken
    bin.install "nmrpflash"
  end

  test do
    system "#{bin}/nmrpflash", "-L"
  end
end
