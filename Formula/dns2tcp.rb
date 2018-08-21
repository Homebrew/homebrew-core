class Dns2tcp < Formula
  desc "TCP over DNS tunnel"
  homepage "https://packages.debian.org/sid/dns2tcp"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/dns2tcp/dns2tcp_0.5.2.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/d/dns2tcp/dns2tcp_0.5.2.orig.tar.gz"
  sha256 "ea9ef59002b86519a43fca320982ae971e2df54cdc54cdb35562c751704278d9"

  bottle do
    cellar :any_skip_relocation
    sha256 "f44f4f2e761da51c4552b6c394ae3ee48e2c1ff8b1b506cf35e648b3331b49dd" => :mojave
    sha256 "d6fb240175854e0a0b5069544a58c4fbcd161d3337288c2f289f48999c4dde10" => :high_sierra
    sha256 "e948ddde1e95f055a9cd3e73cd2756c22f729d9feed9ebc2929cb3df6fe09584" => :sierra
    sha256 "2cd5e77bec42f0f5e2715494c38eb8773ab30d53b140509d3f428d38890bf640" => :el_capitan
    sha256 "3e805ac804eea824b81bd15191b71cdc42d4ac779ebfc1d74d5de51500be18a5" => :yosemite
    sha256 "2f69efb2f705eb1514e8b46d7daa61379df3f4892cfe2d570c233a18ff109e7d" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match(/^dns2tcp v#{version} /,
                 shell_output("#{bin}/dns2tcpc -help 2>&1", 255))
  end
end
