class Packetq < Formula
  desc "SQL-frontend to PCAP-files"
  homepage "https://www.dns-oarc.net/tools/packetq"
  url "https://www.dns-oarc.net/files/packetq/packetq-1.4.0.tar.gz"
  sha256 "cc1b5956ba3a97878e044193f524db426961e3c3413ad01031d3272ea6e4ca78"

  bottle do
    cellar :any_skip_relocation
    sha256 "0272a62174eb6c0097c5942c9aa63774158234d3221b1905767425a7d1994a1a" => :sierra
    sha256 "e2515e9d55249cdc82e3ef8854acc7c509c207ac755ee5ea4dfc170c638744ea" => :el_capitan
    sha256 "8dac4f6f08064639c090863705a044f73432206e189e00d56ee3e15d7cc8e4f3" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/packetq --csv -s 'select id from dns' -")
    assert_equal '"id"', output.chomp
  end
end
