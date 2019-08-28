class Cvsync < Formula
  desc "Portable CVS repository synchronization utility"
  homepage "https://www.cvsync.org/"
  url "https://www.cvsync.org/dist/cvsync-0.24.19.tar.gz"
  sha256 "75d99fc387612cb47141de4d59cb3ba1d2965157230f10015fbaa3a1c3b27560"

  bottle do
    rebuild 1
    sha256 "d013612af119b2f7361bc76264fb3f803798bc95570b935f7b661ed22f272599" => :mojave
    sha256 "77f37d3a029bced4283a805186c371c11525cf678d760cbe0095a248afe6c6a8" => :high_sierra
    sha256 "fcea1a0cb513de493fdf74adca3ca2a6d07ca78638521412d8bc9dbed0c0b5c4" => :sierra
    sha256 "f76f09e679c8bfe1454cc0602fe38c119ec94af456716ead97add4244f2eb2b0" => :el_capitan
  end

  depends_on "openssl@1.1"

  def install
    ENV["PREFIX"] = prefix
    ENV["MANDIR"] = man
    ENV["CVSYNC_DEFAULT_CONFIG"] = etc/"cvsync.conf"
    ENV["CVSYNCD_DEFAULT_CONFIG"] = etc/"cvsyncd.conf"
    ENV["HASH_TYPE"] = "openssl"

    # Makefile from 2005 assumes Darwin doesn't define `socklen_t' and defines
    # it with a CC macro parameter making gcc unhappy about double define.
    inreplace "mk/network.mk",
      /^CFLAGS \+= \-Dsocklen_t=int/, ""

    # Remove owner and group parameters from install.
    inreplace "mk/base.mk",
      /^INSTALL_(.{3})_OPTS\?=.*/, 'INSTALL_\1_OPTS?= -c -m ${\1MODE}'

    # These paths must exist or "make install" fails.
    bin.mkpath
    lib.mkpath
    man1.mkpath

    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cvsync -h 2>&1", 1)
  end
end
