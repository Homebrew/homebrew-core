class DvdxrwTools < Formula
  desc "DVD+-RW/R tools"
  homepage "http://fy.chalmers.se/~appro/linux/DVD+RW/"
  url "http://fy.chalmers.se/~appro/linux/DVD+RW/tools/dvd+rw-tools-7.1.tar.gz"
  sha256 "f8d60f822e914128bcbc5f64fbe3ed131cbff9045dca7e12c5b77b26edde72ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "932e3879247dd1587f35d99c7132c302ddeaf3b5efad9effb05f5b086a55541a" => :sierra
    sha256 "01bae78a5187a47ea770a9cb9c0cabdbafb60485e333a563240a6ea74d6718b0" => :el_capitan
    sha256 "13fa5b14889c82bd2ff44d4da2ba8049603bdfc6026196440fe33102939faa06" => :yosemite
    sha256 "834a3e5e1276e77a9dd5182d60b55484599bd5d705e6bb0d89a8db5720b7e197" => :mavericks
  end

  # Respect $PREFIX
  patch :DATA

  def install
    bin.mkpath
    man1.mkpath
    system "make", "PREFIX=#{prefix}", "install"
  end
end

__END__
diff --git a/Makefile.m4 b/Makefile.m4
index a6a100b..bf7c041 100644
--- a/Makefile.m4
+++ b/Makefile.m4
@@ -30,8 +30,8 @@ LINK.o	=$(LINK.cc)
 # to install set-root-uid, `make BIN_MODE=04755 install'...
 BIN_MODE?=0755
 install:	dvd+rw-tools
-	install -o root -m $(BIN_MODE) $(CHAIN) /usr/bin
-	install -o root -m 0644 growisofs.1 /usr/share/man/man1
+	install -m $(BIN_MODE) $(CHAIN) $(PREFIX)/bin
+	install -m 0644 growisofs.1 $(PREFIX)/share/man/man1
 ])
 
 ifelse(OS,MINGW32,[
