class Bgpq3 < Formula
  desc "BGP filtering automation for Cisco, Juniper, BIRD and OpenBGPD routers"
  homepage "http://snar.spb.ru/prog/bgpq3/"
  url "https://github.com/snar/bgpq3/archive/v0.1.35.tar.gz"
  sha256 "571b99dc4186618ad3c77317eef2c20a8e601ce665a6b0f1ffca6e3d8d804cde"
  head "https://github.com/snar/bgpq3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9fdcf8cfd850d2c304c243fcb974801c5082bac8d06a8ff781843d7a22c71357" => :mojave
    sha256 "baf8c7084ca313d18bc307c9e1fc114a605e4950d067d91250721d7e3672a913" => :high_sierra
    sha256 "0b7ddfe831651eac02b3e5f72a99ecb237f371c27826fff682dd21e3bb3f21a4" => :sierra
    sha256 "f0accebad776f61fba550fad572ff7f7ace7f1d442c21c8147f8594a7f99e561" => :el_capitan
    sha256 "80f717b72e90ed6eb6a25874e52c262f73559ec034764004af35c6df17630acf" => :yosemite
  end

  # Makefile: upstream has been informed of the patch through email (multiple
  # times) but no plans yet to incorporate it https://github.com/snar/bgpq3/pull/2
  # there was discussion about this patch for 0.1.18 and 0.1.19 as well
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/bgpq3", "AS-ANY"
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index c2d7e96..afec780 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -29,9 +29,10 @@ clean:
 	rm -rf *.o *.core core.* core

 install: bgpq3
+	if test ! -d @prefix@/bin ; then mkdir -p @prefix@/bin ; fi
 	${INSTALL} -c -s -m 755 bgpq3 @bindir@
-	if test ! -d @prefix@/man/man8 ; then mkdir -p @prefix@/man/man8 ; fi
-	${INSTALL} -m 644 bgpq3.8 @prefix@/man/man8
+	if test ! -d @mandir@/man8 ; then mkdir -p @mandir@/man8 ; fi
+	${INSTALL} -m 644 bgpq3.8 @mandir@/man8

 depend:
 	makedepend -- $(CFLAGS) -- $(SRCS)
