class Pciutils < Formula
  desc "PCI utilities"
  homepage "https://github.com/pciutils/pciutils"
  url "https://github.com/pciutils/pciutils/archive/refs/tags/v3.15.0.tar.gz"
  sha256 "06f467642057599acf396bc17340452fac3308f1e08be19e0c32587e42d7017b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_linux:  "363c0403500443312c609f1030b16e089f78dd7470ae6446efd4c875d463911d"
    sha256 x86_64_linux: "7c95c0b0a9eb96b489dd2e772e6fa7e1e195fa5a5b679fdeea457b4b9fa8a583"
  end

  depends_on :linux # arm64 macOS is not supported: https://github.com/pciutils/pciutils/issues/111
  depends_on "zlib-ng-compat"

  def install
    args = ["ZLIB=yes", "DNS=yes", "SHARED=yes", "PREFIX=#{prefix}", "MANDIR=#{man}"]
    system "make", *args
    system "make", "install", *args
    system "make", "install-lib", *args
  end

  test do
    assert_match "lspci version", shell_output("#{bin}/lspci --version")
    assert_match(/Host bridge:|controller:/, shell_output("#{bin}/lspci"))
  end
end
