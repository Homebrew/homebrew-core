class Ahcpd < Formula
  desc "Autoconfiguration protocol for IPv6 and IPv6/IPv4 networks"
  homepage "https://www.irif.univ-paris-diderot.fr/~jch/software/ahcp/"
  url "https://www.irif.univ-paris-diderot.fr/~jch/software/files/ahcpd-0.53.tar.gz"
  sha256 "a4622e817d2b2a9b878653f085585bd57f3838cc546cca6028d3b73ffcac0d52"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3f3e332726a04e2cb6a639b18d0092a80cf8d83a9363e75c6579d73ba8ac4d16" => :big_sur
    sha256 "49ef92eb18038f60e6419a5dfecd11be62f3b69cb4778c473050e5443e72ac06" => :arm64_big_sur
    sha256 "9320f1465296a364f0d55ffca9342f087b781f0853ad2213b278189bfc062202" => :catalina
    sha256 "22a512b076e972064d6b0af3eb696a5d2ee62c06aadd2aea01a0bec886d28379" => :mojave
  end

  patch :DATA

  def install
    on_macos do
      # LDLIBS='' fixes: ld: library not found for -lrt
      system "make", "LDLIBS=''"
    end
    on_linux do
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
