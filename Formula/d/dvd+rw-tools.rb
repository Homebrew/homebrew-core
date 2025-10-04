class DvdxrwTools < Formula
  desc "DVD+-RW/R tools"
  # Original URL no longer accessible: https://fy.chalmers.se/~appro/linux/DVD+RW/
  homepage "https://en.wikipedia.org/wiki/Dvd+rw-tools"
  url "https://deb.debian.org/debian/pool/main/d/dvd+rw-tools/dvd+rw-tools_7.1.orig.tar.gz"
  mirror "https://fy.chalmers.se/~appro/linux/DVD+RW/tools/dvd+rw-tools-7.1.tar.gz"
  sha256 "f8d60f822e914128bcbc5f64fbe3ed131cbff9045dca7e12c5b77b26edde72ca"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "8daeeb4d38982c4948e79c9ec20f0e600cbd0c6c55d56bb4f0b14c617e8600e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ef7c367570d1a514f8c5ee0c9a7b9e758dcd12a6ae8ece7fddc835f39ad9b319"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da895c2f501018863f2db497206573a37ef717337e9f5c2dba6a5863bc989d77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "031b8533eeb4ec71ab6f3e2b68826271b0c5ff3e97e0dddaebab9a721b43df53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2cbe68ebfc5a48e4936264261fc269c7c4edf4e0c213dc817d962dcf97a1d86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11ec6e949911cca76b2c3a940e362aff334523a7018dfd3bdcd232acb7b741d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed0da0bd1a96d04a12f9c9f28cedfb9e10d1f1ed09e8e6dbad8d417dddef6e07"
    sha256 cellar: :any_skip_relocation, ventura:        "f87fed662aa38e3ae76443247e6f0db628a70c4dac97e1ef15e036728af4ffb2"
    sha256 cellar: :any_skip_relocation, monterey:       "666563b942edaf7487b15e886264df5dab1cf5a64638ff47dd5f69804a44368d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3d9ab88096123bd36acbad9f27cc21c07fd881f00ac45b49605f18de03262b1"
    sha256 cellar: :any_skip_relocation, catalina:       "18c7e40586199af43cad7bfc604c0e01c90e095a387b425a4e4b74a453423ffe"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7acc04dbb06fd517b729b4ae9b103c1be311d5065b4fac1b6e955704214dbcd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d491eb26d5db91ea03ea2403ae8866675d268a4d9962a4dc9cb4bdb0aedecb47"
  end

  uses_from_macos "m4" => :build

  # Apply Fedora patch for missing header on Linux
  patch do
    on_linux do
      url "https://src.fedoraproject.org/rpms/dvd+rw-tools/raw/938529cda09efcc2f79478be1632648adc3537af/f/dvd+rw-tools-7.1-sysmacro-inc.patch"
      sha256 "28a69bb73c5d819cb445add766e1d68134dc0ec26fe83cc87164ec4853c9541d"
    end
  end

  # Respect $prefix on macOS.
  # Fix build failure because of missing #include <limits.h> on Linux.
  # Patch submitted to author by email.
  patch :DATA

  def install
    ENV.append "CXXFLAGS", "-Wno-reserved-user-defined-literal" if DevelopmentTools.clang_build_version >= 1700
    bin.mkpath
    man1.mkpath
    system "make", "prefix=#{prefix}", "install"
  end
end

__END__
diff --git a/Makefile.m4 b/Makefile.m4
index a6a100b..03fc245 100644
--- a/Makefile.m4
+++ b/Makefile.m4
@@ -27,11 +27,13 @@ CXXFLAGS+=$(WARN) -D__unix -O2 -fno-exceptions
 LDLIBS	=-framework CoreFoundation -framework IOKit
 LINK.o	=$(LINK.cc)

+prefix?=/usr
+
 # to install set-root-uid, `make BIN_MODE=04755 install'...
 BIN_MODE?=0755
 install:	dvd+rw-tools
-	install -o root -m $(BIN_MODE) $(CHAIN) /usr/bin
-	install -o root -m 0644 growisofs.1 /usr/share/man/man1
+	install -m $(BIN_MODE) $(CHAIN) $(prefix)/bin
+	install -m 0644 growisofs.1 $(prefix)/share/man/man1
 ])

 ifelse(OS,MINGW32,[
diff --git a/transport.hxx b/transport.hxx
index 35a57a7..467ce50 100644
--- a/transport.hxx
+++ b/transport.hxx
@@ -16,6 +16,7 @@
 #include <fcntl.h>
 #include <poll.h>
 #include <sys/time.h>
+#include <limits.h>

 inline long getmsecs()
 { struct timeval tv;
