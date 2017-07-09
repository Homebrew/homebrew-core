class Packetq < Formula
  desc "SQL-frontend to PCAP-files"
  homepage "https://www.dns-oarc.net/tools/packetq"
  url "https://www.dns-oarc.net/files/packetq/packetq-1.3.1.tar.gz"
  sha256 "b787ad2d2446f43fd494ef82a587cb79e6e69a85bbbf131c9c64258f0359acff"

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
