class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "0ec8ef7544a551ccbf6fce5c6c535f69cb3ad10e4d5e70e620ecd47fef90a13e"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6b8fe6b2bfc5f3a6f14306459ec7e13b6691de88cae403a911db55a93ad0bc02"
    sha256 cellar: :any,                 arm64_sonoma:  "0c2c34b058e1a855d2abe7de2df0b67c27fc861609a8578fd6dd2e54657aa63e"
    sha256 cellar: :any,                 arm64_ventura: "efd7e73f50633f369299429175a65b38d9ef69691acc98b7bdd9b4d237827424"
    sha256 cellar: :any,                 sonoma:        "2d59fc558170dc24256a5cd1019157f20bcd978ec53296d89fa17dde0485606d"
    sha256 cellar: :any,                 ventura:       "b3d3f595792363a889b76657bd139e5d7f1014ab3cc45e42d5c6ba7b3fe9fb6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25d07d284e4494c038603a297fbe75ade3a0b374cfe1069ffa8674cb49cd4216"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  conflicts_with "libtorrent-rasterbar",
    because: "they both use the same libname"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <string>
      #include <torrent/torrent.h>
      int main(int argc, char* argv[])
      {
        return strcmp(torrent::version(), argv[1]);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-ltorrent"
    system "./test", version.to_s
  end
end
