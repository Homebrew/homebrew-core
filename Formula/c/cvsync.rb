class Cvsync < Formula
  desc "Portable CVS repository synchronization utility"
  homepage "https://www.cvsync.org/"
  url "https://www.cvsync.org/dist/cvsync-0.24.20.tar.bz2"
  sha256 "38fe7ed5e5b8e93858cf59484e0c3e661a52fb82177f73ce29e6170d3069a2a5"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?cvsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3c2601073ec5771e6ab2104ec21df0e1f5e8f4cd5a6a5cfcd28095b97dc76b01"
    sha256 cellar: :any,                 arm64_sequoia: "97e69645f32fa5a2da98aacd8d6faf2097199f3286646a80ea8ff7d4a3a8e9c6"
    sha256 cellar: :any,                 arm64_sonoma:  "aab979cd1f10bcc4c3d9c7d66d22e994a66828b9db91ac347a27d95b6f5fa59d"
    sha256 cellar: :any,                 sonoma:        "78f157d2bf12df8c597c79bab3e219c60b066f160df5573fc15ffce1532dca73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58f5f85beca9a525eb6c1bf14a704f787cb5df82e663f44c6d5ef355694c3d87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85f8e458723da82ca2a67ada72485c5c6e58b6e7790ea707dc527ae3f996a560"
  end

  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["PREFIX"] = prefix
    ENV["MANDIR"] = man
    ENV["CVSYNC_DEFAULT_CONFIG"] = etc/"cvsync.conf"
    ENV["CVSYNCD_DEFAULT_CONFIG"] = etc/"cvsyncd.conf"
    ENV["HASH_TYPE"] = "openssl"

    # Makefile from 2005 assumes Darwin doesn't define `socklen_t' and defines
    # it with a CC macro parameter making gcc unhappy about double define.
    inreplace "mk/network.mk",
      /^CFLAGS \+= -Dsocklen_t=int/, ""

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
