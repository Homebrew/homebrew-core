class Pciutils < Formula
  desc "PCI utilities"
  homepage "https://github.com/pciutils/pciutils"
  url "https://github.com/pciutils/pciutils/archive/refs/tags/v3.11.1.tar.gz"
  sha256 "464644e3542a8d3aaf5373a2be6cb9ddfaa583cb39fbafbbedc10ca458fb48a1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 x86_64_linux: "ea4685bfdd96999e849fb9ac842707cac9965a755f116f86c9ed82614d480de7"
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
