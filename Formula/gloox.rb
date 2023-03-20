class Gloox < Formula
  desc "C++ Jabber/XMPP library that handles the low-level protocol"
  homepage "https://camaya.net/gloox/"
  url "https://camaya.net/download/gloox-1.0.26.tar.bz2"
  sha256 "6b45b390d3b0346a3cf6cc118d5ccafcdf10d51be57a02b0076edf064033ab6f"
  license "GPL-3.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/Latest stable version.*?href=.*?gloox[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "aef98b49f8fb8dd432a4829e1d6593296b834a1bfb2d0e30f8da71051a407874"
    sha256 cellar: :any,                 arm64_monterey: "2678002344c08b7563dfae8ea5fed3d5dee43312497f1a7e1aa75ae5cdca2e3c"
    sha256 cellar: :any,                 arm64_big_sur:  "44a71f390b48f712f943db5967e41b0652a13a135527575a65a3ecd0222900b6"
    sha256 cellar: :any,                 ventura:        "9b73dec9102d5c154a90ae3dd93f09d4faf4bbcd2c1721c1f03b50e870f6306d"
    sha256 cellar: :any,                 monterey:       "0d6c4f0cd746c58aa14df72bc30c2834edd8bcf806e8b3732a3b2dc932f997d1"
    sha256 cellar: :any,                 big_sur:        "e7e5fe65ca1a55c3f345ac9aac5acfab64f8e9a8ada53dfe3fedab9356beaf0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6942ef04f2b7f25a77719fec0c1ae687620a366ea0e9c0475baad6ba00464ca"
  end

  depends_on "pkg-config" => :build
  depends_on "libidn"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-zlib",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "--without-tests",
                          "--without-examples"
    system "make", "install"
  end

  test do
    system bin/"gloox-config", "--cflags", "--libs", "--version"
  end
end
