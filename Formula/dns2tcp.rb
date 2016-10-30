class Dns2tcp < Formula
  desc "TCP over DNS tunnel"
  homepage "http://www.hsc.fr/ressources/outils/dns2tcp/index.html.en"
  url "http://www.hsc.fr/ressources/outils/dns2tcp/download/dns2tcp-0.5.2.tar.gz"
  sha256 "ea9ef59002b86519a43fca320982ae971e2df54cdc54cdb35562c751704278d9"

  bottle do
    cellar :any_skip_relocation
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
