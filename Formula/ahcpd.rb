class Ahcpd < Formula
  desc "Autoconfiguration protocol for IPv6 and IPv6/IPv4 networks"
  homepage "https://www.irif.univ-paris-diderot.fr/~jch/software/ahcp/"
  url "https://www.irif.univ-paris-diderot.fr/~jch/software/files/ahcpd-0.53.tar.gz"
  sha256 "a4622e817d2b2a9b878653f085585bd57f3838cc546cca6028d3b73ffcac0d52"

  bottle do
    cellar :any_skip_relocation
    sha256 "8852e7e5e11d6ea413657d012e4d49ca0d9ac406e56da6bf7c0daa6d4d788a16" => :mojave
    sha256 "ab3221a9f28ded916f8d2ef4b8377a2a793fa2fee5f891b9a97e3dede0d294ae" => :high_sierra
    sha256 "d3a8a4efb712e2c6a8a055276e5d93d3275a638df4231a4dfe8d428a2606d776" => :sierra
    sha256 "b37143ee365a4a3afd9623d5f49eab0bc4bdf9ac3662d22db9671cffa1078224" => :el_capitan
    sha256 "36907bc1aadc9d9d874ebd74624d8c2c2e8b4057181df1e964720a41f72ccae8" => :yosemite
    sha256 "8518f82187d2b8d2bc24648bd072f19073e159abb2bdaf5418ad31e3ab966d0b" => :mavericks
  end

  patch :DATA

  def install
    system "make", "LDLIBS=''"
    system "make", "install", "PREFIX=", "TARGET=#{prefix}"
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
