class Cvsync < Formula
  desc "Portable CVS repository synchronization utility"
  homepage "https://www.cvsync.org/"
  url "https://www.cvsync.org/dist/cvsync-0.24.20.tar.bz2"
  sha256 "38fe7ed5e5b8e93858cf59484e0c3e661a52fb82177f73ce29e6170d3069a2a5"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?cvsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b81c4d24167e797f64465c3060f8a8d28529255c229998c8bb726be119aa1028"
    sha256 cellar: :any,                 arm64_sequoia: "7309da9877789f2a01a29b5adca987e3d5cca4825ee349042c9211eea0f96774"
    sha256 cellar: :any,                 arm64_sonoma:  "a7e5a9da3977ccc2c20daa0eeac3ac6069dd5d026bb6d86aa40c4219432c9040"
    sha256 cellar: :any,                 sonoma:        "5759b950487eb0317d3424292d3ab47866bc408ff81909d731cbda79c80d5954"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd83b23b9450d46c8c72da4f914d969f359073dceb5b48cbaea6bd464123cc2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34a2636df942bc8fabaf8112d319f14b037e04dd3a43c9f8948ca0be77cca8fd"
  end

  depends_on "openssl@3"

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
