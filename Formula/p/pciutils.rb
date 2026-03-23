class Pciutils < Formula
  desc "PCI utilities"
  homepage "https://github.com/pciutils/pciutils"
  url "https://github.com/pciutils/pciutils/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "9f99bb89876510435fbfc47bbc8653bc57e736a21915ec0404e0610460756cb8"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_linux:  "1365e67a35ba8ba7e9ab1988409a040861f7086a21e98ba80a61c634ba022cd2"
    sha256 x86_64_linux: "a202068569c6c4beb49b207d584ffbf6a586ef55cb330e7fe305bda336bd1ea8"
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
