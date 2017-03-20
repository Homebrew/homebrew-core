class Cowsay < Formula
  desc "Configurable talking characters in ASCII art"
  # Historical homepage: https://web.archive.org/web/20120225123719/www.nog.net/~tony/warez/cowsay.shtml
  homepage "https://github.com/tnalpgge/rank-amateur-cowsay"
  url "https://github.com/tnalpgge/rank-amateur-cowsay/archive/cowsay-3.04.tar.gz"
  sha256 "d8b871332cfc1f0b6c16832ecca413ca0ac14d58626491a6733829e3d655878b"

  bottle do
    cellar :any_skip_relocation
    sha256 "17a1a4620885c9a4b7104b43072ed32348b37f6bb43a1120fe23a46d893e87ea" => :sierra
    sha256 "360390af15a3c4793e07eda95f55f4a5466ffafc766cb6b62f9790146080a62a" => :el_capitan
    sha256 "a622af361a6139bc930b371fbde7cfc54bbe8bebfbbe0782e59248fadb10b95f" => :yosemite
    sha256 "185bfafd379cd6f6d6202fdae0750fdd2998cc94f33ea349bd4872a0274cb1dc" => :mavericks
  end

  def install
    system "/bin/sh", "install.sh", prefix
    mv prefix/"man", share
  end

  test do
    output = shell_output("#{bin}/cowsay moo")
    assert_match "moo", output  # bubble
    assert_match "^__^", output # cow
  end
end
