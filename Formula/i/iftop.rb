# Version is "pre-release", but is what Debian, MacPorts, etc.
# package, and upstream has not had any movement in a long time.
class Iftop < Formula
  desc "Display an interface's bandwidth usage"
  homepage "https://pdw.ex-parrot.com/iftop/"
  url "https://pdw.ex-parrot.com/iftop/download/iftop-1.0pre4.tar.gz"
  sha256 "f733eeea371a7577f8fe353d86dd88d16f5b2a2e702bd96f5ffb2c197d9b4f97"
  license "GPL-2.0-or-later"

  # We have to allow the regex to match prerelease versions (e.g., 1.0pre4)
  # until there's a new stable version. The newest version was released on
  # 2014-01-19, so it could be a while.
  livecheck do
    url "https://pdw.ex-parrot.com/iftop/download/"
    regex(/href=.*?iftop[._-]v?(\d+(?:\.\d+)+(?:pre\d+)?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "67c10b03293053b57eb788b632e71ecb2f4bb4eb56d5a2766b1838a654866413"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6a3d6d2dbbb5f10a3cc0043846d9742314b1795d77f08dae5a2ce8abfe9696f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f516ed09bb4c7f8b6fb01626b6a822a382c88d5a26329798f3139f7998192f6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b385697e4cd0da7d4c88d0e9b1425653086fca957782db41c2b2ed93dbe0f9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4656226f9f98a40b6b4dee8c6af89d09f6d34b506663e7cbd985935d74285529"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f97b05b386f2d60baf56d271e6ced20679c9bc38b147479d65bb78baa84d19d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8d45797f98dcb4ef91e762c716766de3da3c04b7c977300ea4e73ff34b8712d"
    sha256 cellar: :any_skip_relocation, ventura:        "fc562e7e272bf086b60ecc29385410ddd173d3814f500c6d880a6c4c0afa8a56"
    sha256 cellar: :any_skip_relocation, monterey:       "e68a2edd94cef76e72ce249aca7ba6b6eed43e839fae0c55efcbc90c3f88758a"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd0f1539789e93b6b2149414831853597471ffcdf92759de42470704b4aaed57"
    sha256 cellar: :any_skip_relocation, catalina:       "8f40152f928f5f63f777b7dd1780951d451defffb30517f657b1850448a2f5ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "74167e8ae57c728a312c3008a6039f7ef440bc59e0cd6f7a80db27a244697133"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eef5cd5b14c8b7b2e7964b39a3833a2cbe3253d93905157f92632c78555a8190"
  end

  head do
    url "https://code.blinkace.com/pdw/iftop.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # (resolves "multiple definition of `...'" errors)
    ENV.append_to_cflags "-fcommon" if OS.linux?

    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      iftop requires root privileges so you will need to run `sudo iftop`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    assert_match "interface:", pipe_output("#{sbin}/iftop -t -s 1 2>&1")
  end
end
