class Fakeroot < Formula
  desc "Provide a fake root environment"
  homepage "https://tracker.debian.org/pkg/fakeroot"
  url "https://deb.debian.org/debian/pool/main/f/fakeroot/fakeroot_1.35.orig.tar.gz"
  sha256 "e5a427b4ab1eb4a2158b3312547a4155aede58735cd5c2910421988834b440a4"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/f/fakeroot/"
    regex(/href=.*?fakeroot[._-]v?(\d+(?:\.\d+)+)[._-]orig\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "72011d7a6ab77df0d175e5eea69ba257b50d8b5c77bd8bb4d54b12139d4970d3"
    sha256 cellar: :any,                 arm64_ventura:  "71a31debb6559d221a9804dd9f0297620b176f2ee09dd806af809874e64ea977"
    sha256 cellar: :any,                 arm64_monterey: "945602311b20f923c2996d2c2b881ed00866f14a5afacc4044045f1aeafb5489"
    sha256 cellar: :any,                 sonoma:         "b1af58ac78e12d3a9946c44729bd06ea57355bb5e61f700d76e744b2ae667437"
    sha256 cellar: :any,                 ventura:        "812798c4eb5a49ce0c6d0d3688b82ca7737570cffffe0a9046c3001ff547726b"
    sha256 cellar: :any,                 monterey:       "efa1be8d3409b8299d02b9239b61334b977a6659bcf0c9676a8f223a92614794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e50b091c9eecd84da0b487351c486132df03e7f6284f8524698fd17009c7f1d"
  end

  # Needed to apply patches below. Remove when no longer needed.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_linux do
    depends_on "libcap" => :build
  end

  # https://salsa.debian.org/clint/fakeroot/-/merge_requests/17
  patch :p0 do
    # The MR has a typo, so we use MacPorts' version.
    url "https://raw.githubusercontent.com/macports/macports-ports/0ffd857cab7b021f9dbf2cbc876d8025b6aefeff/sysutils/fakeroot/files/patch-message.h.diff"
    sha256 "6540eef1c31ffb4ed636c1f4750ee668d2effdfe308d975d835aa518731c72dc"
  end

  def install
    system "./bootstrap" # remove when patches are no longer needed

    args = ["--disable-silent-rules"]
    args << "--disable-static" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fakeroot -v")
  end
end
