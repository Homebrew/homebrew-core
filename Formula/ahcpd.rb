class Ahcpd < Formula
  desc "Autoconfiguration protocol for IPv6 and IPv6/IPv4 networks"
  homepage "https://www.irif.univ-paris-diderot.fr/~jch/software/ahcp/"
  url "https://www.irif.univ-paris-diderot.fr/~jch/software/files/ahcpd-0.53.tar.gz"
  sha256 "a4622e817d2b2a9b878653f085585bd57f3838cc546cca6028d3b73ffcac0d52"
  license "MIT"

  livecheck do
    url "https://www.irif.fr/~jch/software/files/"
    regex(/href=.*?ahcpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ca4d84aac5c8fe54641405340ea2a397a5c6916913b4bd70392d6beb08f8f2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49ef92eb18038f60e6419a5dfecd11be62f3b69cb4778c473050e5443e72ac06"
    sha256 cellar: :any_skip_relocation, monterey:       "d715f5dc18a9b7dbc91fd34a767c22519f71aabcb62c6a479986b6f6472ad71a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f3e332726a04e2cb6a639b18d0092a80cf8d83a9363e75c6579d73ba8ac4d16"
    sha256 cellar: :any_skip_relocation, catalina:       "9320f1465296a364f0d55ffca9342f087b781f0853ad2213b278189bfc062202"
    sha256 cellar: :any_skip_relocation, mojave:         "22a512b076e972064d6b0af3eb696a5d2ee62c06aadd2aea01a0bec886d28379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2007cca57256875a13c8dc554e48d2bbfc9b061101bbd2f24f07910b75f0aa00"
  end

  patch :DATA

  def install
    if OS.mac?
      # LDLIBS='' fixes: ld: library not found for -lrt
      system "make", "LDLIBS=''"
    else
      system "make"
    end
    system "make", "install", "PREFIX=", "TARGET=#{prefix}"
  end

  test do
    pid_file = testpath/"ahcpd.pid"
    log_file = testpath/"ahcpd.log"
    mkdir testpath/"leases"

    (testpath/"ahcpd.conf").write <<~EOS
      mode server

      prefix fde6:20f5:c9ac:358::/64
      prefix 192.168.4.128/25
      lease-dir #{testpath}/leases
      name-server fde6:20f5:c9ac:358::1
      name-server 192.168.4.1
      ntp-server 192.168.4.2
    EOS

    system "#{bin}/ahcpd", "-c", "ahcpd.conf", "-I", pid_file, "-L", log_file, "-D", "lo0"
    sleep(2)

    assert_predicate pid_file, :exist?, "The file containing the PID of the child process was not created."
    assert_predicate log_file, :exist?, "The file containing the log was not created."

    Process.kill("TERM", pid_file.read.to_i)
  end
end

__END__
diff --git a/Makefile b/Makefile
index e52eeb7..28e1043 100644
--- a/Makefile
+++ b/Makefile
@@ -40,8 +40,8 @@ install.minimal: all
	chmod +x $(TARGET)/etc/ahcp/ahcp-config.sh

 install: all install.minimal
-	mkdir -p $(TARGET)$(PREFIX)/man/man8/
-	cp -f ahcpd.man $(TARGET)$(PREFIX)/man/man8/ahcpd.8
+	mkdir -p $(TARGET)$(PREFIX)/share/man/man8/
+	cp -f ahcpd.man $(TARGET)$(PREFIX)/share/man/man8/ahcpd.8

 .PHONY: uninstall

@@ -49,7 +49,7 @@ uninstall:
	-rm -f $(TARGET)$(PREFIX)/bin/ahcpd
	-rm -f $(TARGET)$(PREFIX)/bin/ahcp-config.sh
	-rm -f $(TARGET)$(PREFIX)/bin/ahcp-dummy-config.sh
-	-rm -f $(TARGET)$(PREFIX)/man/man8/ahcpd.8
+	-rm -f $(TARGET)$(PREFIX)/share/man/man8/ahcpd.8

 .PHONY: clean
