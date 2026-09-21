class Btfs < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/refs/tags/v3.3.tar.gz"
  sha256 "9658625244a88e836bfbed53928c104907fc46bdfffb91225284ea8b6947f5a6"
  license "GPL-3.0-only"
  head "https://github.com/johang/btfs.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_linux:  "eb948a0bf2357f0e472063f8d92dd06541c129c111420276db81c700d4045101"
    sha256 cellar: :any, x86_64_linux: "6b2a70164a0ebbd38b1f8b5fcff95d70d1428077eccaa91c0aa040265776930c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "libfuse"
  depends_on "libtorrent-rasterbar"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@3"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"btfs", "--help"
  end
end
