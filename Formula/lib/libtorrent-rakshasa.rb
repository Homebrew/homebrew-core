class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.13.8.tar.gz"
  sha256 "0f6c2e7ffd3a1723ab47fdac785ec40f85c0a5b5a42c1d002272205b988be722"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "9317851dfcfae89f25254c8c5b7dde87ae5ddff6845f65067af9d181b2e53423"
    sha256 cellar: :any,                 arm64_ventura:  "379e99e3801c7e703f998612e750dd93672fd24805725ebef3b665c3c86f8b81"
    sha256 cellar: :any,                 arm64_monterey: "549f2adddde6fc9af3aaf1839225a61bbe157c0a93b32d5acf9ac019ad2877e8"
    sha256 cellar: :any,                 arm64_big_sur:  "c1a7a9b145c6f284bcb967af9af8e3ea3283cc0d00ba1028819170353b7afc44"
    sha256 cellar: :any,                 sonoma:         "63de69fbf75463e74e33687a74fcc7db2a940d30e943e51488f2913bf0e3ef3c"
    sha256 cellar: :any,                 ventura:        "e8658b9542a25a3c5c783d7945381f897dabdcb07684e0e4c5fb0b9bac9521d5"
    sha256 cellar: :any,                 monterey:       "be0c226697f610c2b2593b150608cd333710da4480eea29ebc4d291b8f17955d"
    sha256 cellar: :any,                 big_sur:        "b3595f86917cf3e9025b063cc24b08bea158da105f49d3bb974456f1fa46c546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "733fb0be216ee03ae9394ba639fbc1d4d2e2f9299c8d91b93117e0e6074c5906"
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
    system "sh", "autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules"
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
