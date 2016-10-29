class Ncrack < Formula
  desc "Network authentication cracking tool"
  homepage "https://nmap.org/ncrack/"
  url "https://nmap.org/ncrack/dist/ncrack-0.5.tar.gz"
  sha256 "dbad9440c861831836d47ece95aeb2bd40374a3eb03a14dea0fe1bfa73ecd4bc"

  bottle do
    rebuild 2
    sha256 "ce28c99cbc61ca885f0b2ca87d290022d4ea76fe53653ec80773e14900bb2583" => :sierra
    sha256 "d45494a77a6fdb47ab7b262a9872a650646ac8ddbaf51bd27c51e2f47fdc2c78" => :el_capitan
    sha256 "ba283e5523dba87de24ca49fd6aeddd52b25de66313d13ba5105ade949a1b598" => :mavericks
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match("\nNcrack version 0.5 ( http://ncrack.org )\nModules: FTP, SSH, Telnet, HTTP(S), POP3(S), SMB, RDP, VNC, SIP, Redis, PostgreSQL, MySQL", shell_output(bin/"ncrack --version"))
  end
end
