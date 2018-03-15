class Packetq < Formula
  desc "SQL-frontend to PCAP-files"
  homepage "https://www.dns-oarc.net/tools/packetq"
  url "https://www.dns-oarc.net/files/packetq/packetq-1.4.1.tar.gz"
  sha256 "de374930dcc36c4b23ef4807ac798016fef6f45d29d3464f993df21e154e57d1"

  bottle do
    cellar :any_skip_relocation
    sha256 "299409c99a253199b8b5896ecc8f1490ef4989ff72b10abd2651981a0bd47974" => :high_sierra
    sha256 "eda7fdbbfc232e370b03e762c24551e92c3207f23f66e42db1c9ec10c448e1e1" => :sierra
    sha256 "1cc4d10a81e062c41d7641d8fc3a7e94a1bf3b9e92ad6c4d70c8bdc730cee1d4" => :el_capitan
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
