class Pciutils < Formula
  desc "PCI utilities"
  homepage "https://github.com/pciutils/pciutils"
  url "https://github.com/pciutils/pciutils/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "9f99bb89876510435fbfc47bbc8653bc57e736a21915ec0404e0610460756cb8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_linux:  "04bcc2da98a252bebdd8b6206957de9b5d4409c58fe2533197fcc6b3a71eed5f"
    sha256 x86_64_linux: "684b1f7d95352c1d14a3a9431c7cccf4e5326e6e80c517d092afd8bd7d860fdf"
  end

  depends_on :linux # arm64 macOS is not supported: https://github.com/pciutils/pciutils/issues/111
  depends_on "zlib"

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
