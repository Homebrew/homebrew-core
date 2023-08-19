class Cvsync < Formula
  desc "Portable CVS repository synchronization utility"
  homepage "https://www.cvsync.org/"
  url "https://www.cvsync.org/dist/cvsync-0.24.19.tar.gz"
  sha256 "75d99fc387612cb47141de4d59cb3ba1d2965157230f10015fbaa3a1c3b27560"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?cvsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_ventura:  "86f6fe30422f903827d29782f74e2eff93e7a2f0a86b4775747c9077cde03564"
    sha256 cellar: :any,                 arm64_monterey: "151a5a709d78dfd6fe1db43686e7d0a7bf9464184133b5a79152a8d21aeb44e0"
    sha256 cellar: :any,                 arm64_big_sur:  "284f786b36c5890da6c1d889cbf02a50c116a03661183b088dedb6a3ccdf4c05"
    sha256 cellar: :any,                 ventura:        "ac33e5ee664d62d33043535d589ca4e526780073fed1801bc642d16f528a3402"
    sha256 cellar: :any,                 monterey:       "8f9856b5b0be6da7e213fb287be69259d8aaf8425fa057702242109f393aeae9"
    sha256 cellar: :any,                 big_sur:        "c53b78803c36ffe5b389b7891a51c8197b05e9d660c5100417fa5fd9f743cfd8"
    sha256 cellar: :any,                 catalina:       "358f4234cde20c14d3af19a226c294154361a8159802755029f43a7f6d81fd27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "450f89a4983c03d8b007667d044047796ed721e7a6ce3fac437260c25d33219d"
  end

  depends_on "openssl@3"

  uses_from_macos "zlib"

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
