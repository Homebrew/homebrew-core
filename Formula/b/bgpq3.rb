class Bgpq3 < Formula
  desc "BGP filtering automation for Cisco, Juniper, BIRD and OpenBGPD routers"
  homepage "http://snar.spb.ru/prog/bgpq3/"
  url "https://github.com/snar/bgpq3/archive/refs/tags/v0.1.38.tar.gz"
  sha256 "c4a424825e6c9c9ec48c2583dcbbfc3016d15cc0be1dc55d07827e1b9b79888c"
  license "BSD-2-Clause"
  head "https://github.com/snar/bgpq3.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bf0242ea13e9360cd13d475dd15be3f7c889c831a4110194e1f7fed18aaedf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "234036f637e3d392114a9a92637f28f59820c407803d414e9efff4cde922e506"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20e940f3930fc35fdb480f156780d53cebe5c18b26e231db42f0667d77d87b50"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c59144d7fa15c862bfdeb5af564871eb28cfbc6112d6e985d9be636de0deee4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f29830a26cca0ebac56d0978d1265d9078c09f782c23062710262296750d916"
    sha256 cellar: :any_skip_relocation, ventura:       "19510346a7393c8b478610831da0a8d5060932feb543fb48d37709d09cac061b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5ad42018e54795c6aa663b7cf201eee6abbec7ccd6403041d619b4ecdd2dfa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c79dfd70b5f7abf543be803c8f3e65b1c42b5dc746a9380e923599062e360a63"
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
    system bin/"bgpq3", "AS-ANY"
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
