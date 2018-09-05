class Netcat6 < Formula
  desc "Rewrite of netcat that supports IPv6, plus other improvements"
  homepage "https://www.deepspace6.net/projects/netcat6.html"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/n/nc6/nc6_1.0.orig.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/n/nc6/nc6_1.0.orig.tar.gz"
  sha256 "db7462839dd135ff1215911157b666df8512df6f7343a075b2f9a2ef46fe5412"

  bottle do
    sha256 "d0f6d99434ded31aebdc49dfa8e918112e816421247ada8dc23ba89614fc8278" => :mojave
    sha256 "42c8ecdb7495f55311d806e7dd3695c2dc664c536d5c6c0f7f0a84f150299a44" => :high_sierra
    sha256 "134b64d2bca03d774a1375c9898504b5aba30de50dff543ca37033b7334fcaa5" => :sierra
    sha256 "75fd93f36d745618b9c87a1f635a100db7fc2c3d659ecf39e77a282bf0efdb1b" => :el_capitan
    sha256 "7020abcd43b4b1714a43e42f468895c6c02ad2a8a214bc36761b6b5f615cd127" => :yosemite
    sha256 "7b1d4a701e8fadedea4e5cc89d7cbcb5bf476476557975a71a681850c50bf872" => :mavericks
    sha256 "361c72d301addec6d417b52535da84dd924fdcdf9794889dc5ac0f240bb31b02" => :mountain_lion
  end

  option "with-silence-patch", "Use silence patch from Debian"

  deprecated_option "silence-patch" => "with-silence-patch"

  patch :p0, :DATA if build.with? "silence-patch"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    assert_match "HTTP/1.0", pipe_output("#{bin}/nc6 www.google.com 80", "GET / HTTP/1.0\r\n\r\n")
  end
end

__END__
# wrap socket-type warnings in very_verbose_mode()
--- src/network.c	2006-01-19 14:46:23.000000000 -0800
+++ src/network.c.new	2014-01-17 11:02:10.000000000 -0800
@@ -21,10 +21,11 @@
  */
 #include "system.h"
 #include "network.h"
 #include "connection.h"
 #include "afindep.h"
+#include "parser.h"
 #ifdef ENABLE_BLUEZ
 #include "bluez.h"
 #endif/*ENABLE_BLUEZ*/

 #include <assert.h>
@@ -290,17 +291,20 @@
	assert(sock >= 0);

	/* announce the socket in very verbose mode */
	switch (socktype) {
	case SOCK_STREAM:
-		warning(_("using stream socket"));
+		if (very_verbose_mode())
+			warning(_("using stream socket"));
		break;
	case SOCK_DGRAM:
-		warning(_("using datagram socket"));
+		if (very_verbose_mode())
+			warning(_("using datagram socket"));
		break;
	case SOCK_SEQPACKET:
-		warning(_("using seqpacket socket"));
+		if (very_verbose_mode())
+			warning(_("using seqpacket socket"));
		break;
	default:
		fatal_internal("unsupported socket type %d", socktype);
	}
