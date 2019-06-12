class Ptpd < Formula
  desc "Precision Time Protocol daemon"
  homepage "https://github.com/ptpd/ptpd"
  url "https://downloads.sourceforge.net/project/ptpd/ptpd/2.3.1/ptpd-2.3.1.tar.gz"
  sha256 "0dbf54dd2c178bd9fe62481d2c37513ee36636d8bf137cfdad96891490cdbf93"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-snmp",
                          "--without-net-snmp-config",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/ptpd2", "--default-config"
  end
end
