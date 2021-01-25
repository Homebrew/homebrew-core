class Ipv6toolkit < Formula
  desc "Security assessment and troubleshooting tool for IPv6"
  homepage "https://www.si6networks.com/research/tools/ipv6toolkit/"
  url "http://pages.cs.wisc.edu/~plonka/ipv6toolkit/ipv6toolkit-v2.0.tar.gz"
  sha256 "16f13d3e7d17940ff53f028ef0090e4aa3a193a224c97728b07ea6e26a19e987"
  license "GPL-3.0-or-later"
  head "https://github.com/fgont/ipv6toolkit.git"

  livecheck do
    url "http://pages.cs.wisc.edu/~plonka/ipv6toolkit/"
    regex(/href=.*?ipv6toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "7ccda456d8eb276a1a462bc06e63167984e5c1a45f58ba453063c5a22b5b31bd" => :big_sur
    sha256 "ee329b82ef00e47b858fe38adc0e0320635c66847c3986dc2e1727fa529173af" => :arm64_big_sur
    sha256 "6ab4963d7d80f42fb444fabe02122f0290842cffd620a38e15060ed1c1b120ef" => :catalina
    sha256 "b589fdd1d51db357ecda7452f10ac8daa48266dc4bb52bd6f3b18864e8e8bcbb" => :mojave
  end

  def install
    system "make"
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX=", "MANPREFIX=/share"
  end

  test do
    system "#{bin}/addr6", "-a", "fc00::1"
  end
end
