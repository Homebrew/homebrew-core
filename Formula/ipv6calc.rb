class Ipv6calc < Formula
  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/2.1.1.tar.gz"
  sha256 "964957e79505cbc71ebc706a0fc0b67c6e08c55ed53335470ed7f8309eb84405"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5816eae9ca8eed194d698a289d1f3d9dedcb93b983cd9761c6dca233d3a5ed7" => :mojave
    sha256 "8803971206dffa1bf5d040199f774e32f052d0d142b674ca41777e3736ab2bb3" => :high_sierra
    sha256 "a5fd2f9e54ffaf981be6f9b4e16a397799ca67ac26bef7680edd4387d734dd65" => :sierra
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
