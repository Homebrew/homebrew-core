class Ipv6calc < Formula
  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/1.0.0.tar.gz"
  sha256 "74b0455e61834843bf8a5e7e0e0f39dd2b148114ff896d590eb2d826714594bd"

  bottle do
    cellar :any_skip_relocation
    sha256 "a67a510d9788019d98836c391811b08af79f0bcbdfa0fc0b7c2ea119b7bc9afd" => :sierra
    sha256 "ef399281d676e0f9d65038fa7d43f7abca807e3aaf437366126a8a1a4f6a8bf6" => :el_capitan
    sha256 "ad4d9073a25962b4321648ee79658e04517d340025cc6ae346342d301cab3a40" => :yosemite
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
