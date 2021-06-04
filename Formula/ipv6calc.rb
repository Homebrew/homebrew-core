class Ipv6calc < Formula
  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/3.1.1.tar.gz"
  sha256 "bc2daa626fd1cf60d8a09e564d7b58efdc47eedd30aab442ec8a188fe12f1016"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8eeb311271874e67e665e0c1cc32fafd38805a4a81d30ea31197e1c2ceaf104c"
    sha256 cellar: :any_skip_relocation, big_sur:       "c1bbb3371e2bf0c3364dc9edd87152aadb85e75342535646a7022f7324b607e0"
    sha256 cellar: :any_skip_relocation, catalina:      "cbbfa59bb3d93e1954dd7c6ecb718baddb1063c6929d57655313c2f4fb29d88c"
    sha256 cellar: :any_skip_relocation, mojave:        "20e5085d6ef92183355f83b5aa2097d4b740685dbfb2143ac355bc49bfe51eff"
  end

  def install
    # This needs --mandir, otherwise it tries to install to /share/man/man8.
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "192.168.251.97",
      shell_output("#{bin}/ipv6calc -q --action conv6to4 --in ipv6 2002:c0a8:fb61::1 --out ipv4").strip
  end
end
