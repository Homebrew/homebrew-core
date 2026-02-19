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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_tahoe:   "462780681001bc3d967095fe7299ea1a80d5c61a97445fa71906b9c313a3d524"
    sha256 cellar: :any,                 arm64_sequoia: "c10b8ee0fac29dacca30b600168f906ba9dba4c8482a43a914c465a0136242b2"
    sha256 cellar: :any,                 arm64_sonoma:  "76c47b6ce6da172873b98ab94ef3e5e538a4e876eb49cea83067526fe79a52d4"
    sha256 cellar: :any,                 sonoma:        "4cd58fd98a0d40e093b9d4bd274713a13abdf3b4937c022d8d1d03fa763bc316"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e57f12788449006737f2a77356c2bd3a4c65e6301e78b8cbe50512087f9f03ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "681d877926aaa76806b946e22c4d254a6b4e82bd22aca241113cf05d1271a5c1"
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
