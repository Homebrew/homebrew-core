class Bgpq3 < Formula
  desc "BGP filtering automation for Cisco, Juniper, BIRD and OpenBGPD routers"
  homepage "http://snar.spb.ru/prog/bgpq3/"
  url "https://github.com/snar/bgpq3/archive/v0.1.36.1.tar.gz"
  sha256 "68d602434d072115b848f6047a7a29812d53c709835a4fbd0ba34dcc31553bcd"
  license "BSD-2-Clause"
  head "https://github.com/snar/bgpq3.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18d4d294bcd85daa37e3285a34aa7ed2d45513cd708a2eadc203d5d62ae7b5a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "890ade49fae97d8e9967362b464b57cc172fb5305e05dee84d7c3b5ab5e869bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9edea14c24ccca9986d9dbf14cedd8e245fc49ecffb07a3079deff2b6576448"
    sha256 cellar: :any_skip_relocation, ventura:        "e5b38623eed774b049c26c2c6b074ffb5302c38f1545ef96458b5a6dfcbdca8b"
    sha256 cellar: :any_skip_relocation, monterey:       "7a130fc4a82b1ab7255290dc18058a369ba604905386a32ac7f76a6bab543ee7"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d04e58f086891a0a8f1bd8c91e813afb4de0fff26f61a8bc30d3c82d2829a42"
    sha256 cellar: :any_skip_relocation, catalina:       "4294f76491ed0fe10c6df11b695489e2765b7eb8bd4ccfe0adcabced418968a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee8fc268ac1e1293ee27d9b8a82411c7dc98f2a4df8e4a88efed3635699bc4ba"
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
--- a/Makefile.in
+++ b/Makefile.in
@@ -32,8 +32,8 @@
 install: bgpq3
 	if test ! -d @bindir@ ; then mkdir -p @bindir@ ; fi
 	${INSTALL} -c -s -m 755 bgpq3 @bindir@
-	if test ! -d @prefix@/man/man8 ; then mkdir -p @prefix@/man/man8 ; fi
-	${INSTALL} -m 644 bgpq3.8 @prefix@/man/man8
+	if test ! -d @mandir@/man8 ; then mkdir -p @mandir@/man8 ; fi
+	${INSTALL} -m 644 bgpq3.8 @mandir@/man8

 depend:
 	makedepend -- $(CFLAGS) -- $(SRCS)
