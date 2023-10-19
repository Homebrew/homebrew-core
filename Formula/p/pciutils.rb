class Pciutils < Formula
  desc "PCI utilities"
  homepage "https://github.com/pciutils/pciutils"
  url "https://github.com/pciutils/pciutils/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "e579d87f1afe2196db7db648857023f80adb500e8194c4488c8b47f9a238c1c6"
  license "GPL-2.0-or-later"

  uses_from_macos "zlib"

  def install
    system "make", "install", "ZLIB=yes", "DNS=yes", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    assert_match "lspci version", shell_output("#{sbin}/lspci --version")
  end
end
