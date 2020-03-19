class Packetq < Formula
  desc "SQL-frontend to PCAP-files"
  homepage "https://www.dns-oarc.net/tools/packetq"
  url "https://www.dns-oarc.net/files/packetq/packetq-1.4.2.tar.gz"
  sha256 "696cfcae6d341b910b86673baa428ffa09d00dd42a70d2d3ac57db13c6977122"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9838e0f004b12ca2b43feb321d4a90c5e2778a22fabd9b9b528b783c0ef98b4" => :catalina
    sha256 "bc56d9875b526794212e1267b17ea7ba24a639f1efaf804fe2f528f334e2854a" => :mojave
    sha256 "6c085b37c22ef43c3dc4bff3c68c8fb2aa02acd5ba83e6767ac3574f00e278f8" => :high_sierra
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
