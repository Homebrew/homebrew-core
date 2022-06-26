class Dopewars < Formula
  desc 'Free rewrite of a game originally based on "Drug Wars"'
  homepage "https://dopewars.sourceforge.io"
  url "https://downloads.sourceforge.net/project/dopewars/dopewars/1.6.1/dopewars-1.6.1.tar.gz"
  sha256 "83127903a61d81cda251a022f9df150d11e27bdd040e858c09c57927cc0edea6"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "90bd8b194058a1428560317d6408c8a280e268435cbddd8038f65b98ec992bb9"
    sha256 arm64_big_sur:  "490e166c6e7a12f93f51271b80aca3d3e6471089e51f77ba30db1ebce1861dcd"
    sha256 monterey:       "4da56bd76735a9bc18dd0d12d4503e4afe218624b18c1d0bb360349969a7037c"
    sha256 big_sur:        "390ce7a719041ebf745d790ea872db927cb587cfc91ddab183472fe2ceecec43"
    sha256 catalina:       "85d6516b31e2bd45f92d2e2c18f773ec2b2990b25da82155454274e8c65eaa3d"
    sha256 mojave:         "abe0910c15903b12be25d3b00f4544f39d10b894c5b773468b7b52e3c403893b"
    sha256 x86_64_linux:   "d210ce88fedc57d16b0561b3bae36be8932ddfddf0bc56485194f0100996efcd"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  uses_from_macos "curl"

  def install
    inreplace "src/Makefile.in", "$(dopewars_DEPENDENCIES)", ""
    inreplace "auxbuild/ltmain.sh", "need_relink=yes", "need_relink=no"
    inreplace "src/plugins/Makefile.in", "LIBADD =", "LIBADD = -module -avoid-version"
    system "./configure", "--disable-gui-client",
                          "--disable-gui-server",
                          "--enable-plugins",
                          "--enable-networking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/dopewars", "-v"
  end
end
