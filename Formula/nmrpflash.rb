class Nmrpflash < Formula
  desc "Netgear Unbrick Utility"
  homepage "https://github.com/jclehner/nmrpflash"
  url "https://github.com/jclehner/nmrpflash/archive/refs/tags/v0.9.17.tar.gz"
  sha256 "fd3193c8c3a10bc50eb01da655570fd7d4fa191f6f489d517f86a85a4fc14681"
  license "GPL-3.0-or-later"

  uses_from_macos "libpcap"

  def install
    system "make", "VERSION=#{version}"
    # "make install" is currently broken
    bin.install "nmrpflash"
  end

  test do
    system "#{bin}/nmrpflash", "-L"
  end
end
