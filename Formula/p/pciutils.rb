class Pciutils < Formula
  desc "PCI utilities"
  homepage "https://github.com/pciutils/pciutils"
  url "https://github.com/pciutils/pciutils/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "861fc26151a4596f5c3cb6f97d6c75c675051fa014959e26fb871c8c932ebc67"
  license "GPL-2.0-or-later"

  bottle do
    sha256 x86_64_linux: "8642b280a07552b6b9e2d4a887963900158155ea00b5cd85558b0f481e8204a8"
  end

  depends_on :linux
  depends_on "zlib"

  def install
    args = ["ZLIB=yes", "DNS=yes", "SHARED=yes", "PREFIX=#{prefix}", "MANDIR=#{man}"]
    system "make", *args
    system "make", "install", *args
    system "make", "install-lib", *args
  end

  test do
    assert_match "lspci version", shell_output("#{bin}/lspci --version")
    assert_match "Host bridge:", shell_output("#{bin}/lspci")
  end
end
