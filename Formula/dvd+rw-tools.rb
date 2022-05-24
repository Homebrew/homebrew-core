class DvdxrwTools < Formula
  desc "DVD+-RW/R tools"
  homepage "http://fy.chalmers.se/~appro/linux/DVD+RW/"
  url "http://fy.chalmers.se/~appro/linux/DVD+RW/tools/dvd+rw-tools-7.1.tar.gz"
  sha256 "f8d60f822e914128bcbc5f64fbe3ed131cbff9045dca7e12c5b77b26edde72ca"
  license "GPL-2.0"

  livecheck do
    url "http://fy.chalmers.se/~appro/linux/DVD+RW/tools/"
    regex(/href=.*?dvd\+rw-tools[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2cbe68ebfc5a48e4936264261fc269c7c4edf4e0c213dc817d962dcf97a1d86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11ec6e949911cca76b2c3a940e362aff334523a7018dfd3bdcd232acb7b741d1"
    sha256 cellar: :any_skip_relocation, monterey:       "666563b942edaf7487b15e886264df5dab1cf5a64638ff47dd5f69804a44368d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3d9ab88096123bd36acbad9f27cc21c07fd881f00ac45b49605f18de03262b1"
    sha256 cellar: :any_skip_relocation, catalina:       "18c7e40586199af43cad7bfc604c0e01c90e095a387b425a4e4b74a453423ffe"
    sha256 cellar: :any_skip_relocation, mojave:         "7d79f2f23e9fb680435005d4491e02d3beb4cbbf2d8abc338b4efe33b7d17988"
    sha256 cellar: :any_skip_relocation, high_sierra:    "acf8d9a92ff74fdbfc409dc42980be607c4dd263aca89444713972a055d5967a"
    sha256 cellar: :any_skip_relocation, sierra:         "932e3879247dd1587f35d99c7132c302ddeaf3b5efad9effb05f5b086a55541a"
    sha256 cellar: :any_skip_relocation, el_capitan:     "01bae78a5187a47ea770a9cb9c0cabdbafb60485e333a563240a6ea74d6718b0"
    sha256 cellar: :any_skip_relocation, yosemite:       "13fa5b14889c82bd2ff44d4da2ba8049603bdfc6026196440fe33102939faa06"
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
