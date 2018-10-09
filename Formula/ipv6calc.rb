class Ipv6calc < Formula
  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/1.1.0.tar.gz"
  sha256 "782d8f9b61520598316530907898038e8adcb76b1c01bc2885650374de8ce4e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e0d6c64f9821f4a34fca5b146e971f8e382ef05de62f1e4ae3fa9ddcbdbef3e" => :mojave
    sha256 "1e64e269dbaf3ca47ed4af72a8bfc11a7bc01c4b9207862207194e024eac2f19" => :high_sierra
    sha256 "fa6ff54f91251f67f00a1786f3f83280fcdc735daf6bd4386f0f836067a5922b" => :sierra
  end

  def install
    # This needs --mandir, otherwise it tries to install to /share/man/man8.
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "192.168.251.97", shell_output("#{bin}/ipv6calc -q --action conv6to4 --in ipv6 2002:c0a8:fb61::1 --out ipv4").strip
  end
end
