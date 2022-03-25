class Ipv6toolkit < Formula
  desc "Security assessment and troubleshooting tool for IPv6"
  homepage "https://www.si6networks.com/research/tools/ipv6toolkit/"
  url "https://pages.cs.wisc.edu/~plonka/ipv6toolkit/ipv6toolkit-v2.0.tar.gz"
  sha256 "16f13d3e7d17940ff53f028ef0090e4aa3a193a224c97728b07ea6e26a19e987"
  license "GPL-3.0-or-later"
  head "https://github.com/fgont/ipv6toolkit.git", branch: "master"

  livecheck do
    url "https://pages.cs.wisc.edu/~plonka/ipv6toolkit/"
    regex(/href=.*?ipv6toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79ca05285bd1af83adba5abc616a2b991fd65c0255466745b0b3a6815d49b0d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee329b82ef00e47b858fe38adc0e0320635c66847c3986dc2e1727fa529173af"
    sha256 cellar: :any_skip_relocation, monterey:       "63e06e58b85f10ca935dbfd52860ef330d734ec7c29425aaa8f33a05037c2979"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ccda456d8eb276a1a462bc06e63167984e5c1a45f58ba453063c5a22b5b31bd"
    sha256 cellar: :any_skip_relocation, catalina:       "6ab4963d7d80f42fb444fabe02122f0290842cffd620a38e15060ed1c1b120ef"
    sha256 cellar: :any_skip_relocation, mojave:         "b589fdd1d51db357ecda7452f10ac8daa48266dc4bb52bd6f3b18864e8e8bcbb"
  end

  uses_from_macos "libpcap"

  def install
    system "make"
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX=", "MANPREFIX=/share"
  end

  test do
    system "#{bin}/addr6", "-a", "fc00::1"
  end
end
