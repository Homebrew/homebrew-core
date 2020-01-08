class Cvsync < Formula
  desc "Portable CVS repository synchronization utility"
  homepage "https://www.cvsync.org/"
  url "https://www.cvsync.org/dist/cvsync-0.24.19.tar.gz"
  sha256 "75d99fc387612cb47141de4d59cb3ba1d2965157230f10015fbaa3a1c3b27560"

  bottle do
    cellar :any
    rebuild 2
    sha256 "da10e78630bf61ac77576e3f10033730bf335e24324681f32c973cd9a2d645be" => :catalina
    sha256 "1a7f82970b208df4bafed99ce20de7f4d94be51f79152ad75c85fb69ecaff51e" => :mojave
    sha256 "1ea4fcb1bcb64f91915919e485b374eb2e16b69fb60f589242c3a140d3c16c7f" => :high_sierra
    sha256 "4e92dd3b6a74831724c2da74f761660fa25630d9c44be9d80a0d72dc522e1fae" => :sierra
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
