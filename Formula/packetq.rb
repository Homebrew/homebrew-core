class Packetq < Formula
  desc "SQL-frontend to PCAP-files"
  homepage "https://www.dns-oarc.net/tools/packetq"
  url "https://www.dns-oarc.net/files/packetq/packetq-1.4.0.tar.gz"
  sha256 "cc1b5956ba3a97878e044193f524db426961e3c3413ad01031d3272ea6e4ca78"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc4d3d447c8d64fe3ae02bbe1307ac5fc14080c197d35510c65970647f72a558" => :sierra
    sha256 "3f2501e1534913dea6d0c5928ffd0ca6d0a60771fca4ab104729e7523882566c" => :el_capitan
    sha256 "319784b955102e90e100a62aa2d2891e1ee9fc4c3fc1112596840182f6b4a3f1" => :yosemite
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
