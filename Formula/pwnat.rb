class Pwnat < Formula
  desc "Proxy server that works behind a NAT"
  homepage "https://samy.pl/pwnat/"
  url "https://samy.pl/pwnat/pwnat-0.3-beta.tgz"
  sha256 "d5d6ea14f1cf0d52e4f946be5c3630d6440f8389e7467c0117d1fe33b9d130a2"

  head "https://github.com/samyk/pwnat.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8319cece67a334c14129e706f9d1b249d7905cf1ad62df9b5ee9553dbb8d001" => :sierra
    sha256 "0149fc977622f2fd55db5845a377437028df31bb847230d3fd73d548e481e289" => :el_capitan
    sha256 "cf17568c4053240ffe61594bcc618577c0d0c569abda8b3b956a4e4b441a755e" => :yosemite
    sha256 "0baed31dc05b28a330501a0d4119e8997c1038d14311c64f2d7b367ebdf9f01e" => :mavericks
    sha256 "ed78a0577b4e2f4555b4c7724cf829032b0af99713c58a5ffd943d21b551b199" => :mountain_lion
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=-lz"
    bin.install "pwnat"
  end

  test do
    shell_output("#{bin}/pwnat -h", 1)
  end
end
