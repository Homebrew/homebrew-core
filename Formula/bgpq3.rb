class Bgpq3 < Formula
  desc "BGP filtering automation for Cisco, Juniper, BIRD and OpenBGPD routers"
  homepage "http://snar.spb.ru/prog/bgpq3/"
  url "https://github.com/snar/bgpq3/archive/v0.1.35.tar.gz"
  sha256 "571b99dc4186618ad3c77317eef2c20a8e601ce665a6b0f1ffca6e3d8d804cde"
  head "https://github.com/snar/bgpq3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "428a0dcb0af2876c03374236ee10b2385ab993dc54cc12e080198d7e552bbdea" => :catalina
    sha256 "a16c482aa8e1a821d6747b2871174109ccbcf407e5799794f6307303fcffafcb" => :mojave
    sha256 "2bf730bec0bca51bd9a3db7a3cd5e4bf36199717a8190db270a5f4751bb1a5e1" => :high_sierra
    sha256 "052fb1ae9a1546b13f865b25f4ff5879f4a7c77350d14720442fc6cd898d833d" => :sierra
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
