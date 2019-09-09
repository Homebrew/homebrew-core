class Ipv6calc < Formula
  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/2.1.1.tar.gz"
  sha256 "964957e79505cbc71ebc706a0fc0b67c6e08c55ed53335470ed7f8309eb84405"

  bottle do
    cellar :any_skip_relocation
    sha256 "1442ca698f227f0eccdff7118381abd8c2b33ecb481bbc39ff5037bec4fefce4" => :mojave
    sha256 "67be87559723f99a220267b3dc085df99ccc40a2b49ccb4801dfb1d745465bbd" => :high_sierra
    sha256 "121e83f0282c80d2a3f515b7b949160ab6d2ffcb1d874e63e4f960919c70b253" => :sierra
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
