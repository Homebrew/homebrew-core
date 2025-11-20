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
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:    "c43def4368772309b8643caeb7345217880da0440f8eb42c8602238e3a676d93"
    sha256 cellar: :any,                 arm64_sequoia:  "c5f77cf63c61c0042ebacea31bc3d2e7548afc08ec738fd6f0a8baf3180b4795"
    sha256 cellar: :any,                 arm64_sonoma:   "db4846fa5c20e6e946dd8b3398ca22de82c934b97018ddab899c0bed8a178d22"
    sha256 cellar: :any,                 arm64_ventura:  "86f6fe30422f903827d29782f74e2eff93e7a2f0a86b4775747c9077cde03564"
    sha256 cellar: :any,                 arm64_monterey: "151a5a709d78dfd6fe1db43686e7d0a7bf9464184133b5a79152a8d21aeb44e0"
    sha256 cellar: :any,                 arm64_big_sur:  "284f786b36c5890da6c1d889cbf02a50c116a03661183b088dedb6a3ccdf4c05"
    sha256 cellar: :any,                 sonoma:         "86a6fb35c944b4b2a19b677659c002eb56dc6d1cd83202f8126e9b06de97d2b0"
    sha256 cellar: :any,                 ventura:        "ac33e5ee664d62d33043535d589ca4e526780073fed1801bc642d16f528a3402"
    sha256 cellar: :any,                 monterey:       "8f9856b5b0be6da7e213fb287be69259d8aaf8425fa057702242109f393aeae9"
    sha256 cellar: :any,                 big_sur:        "c53b78803c36ffe5b389b7891a51c8197b05e9d660c5100417fa5fd9f743cfd8"
    sha256 cellar: :any,                 catalina:       "358f4234cde20c14d3af19a226c294154361a8159802755029f43a7f6d81fd27"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5e81c7a636af467de3b7818076920c840934e74b7e4bd8d0d69d3529967cf003"
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
