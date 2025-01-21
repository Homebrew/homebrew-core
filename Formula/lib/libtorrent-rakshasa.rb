class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "27bdd00949ef0b43161002a475f5eeb777929ad96dddd6c9b2f76f14c9be3a69"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d7bd555455776bed5115c2600dcedd1d3ee8d8bc25e2323c23615a61eca8c747"
    sha256 cellar: :any,                 arm64_sonoma:  "385252879a27d65f18ce1aaed8223d5a62245ae89eb6124741ced83a306f5dbe"
    sha256 cellar: :any,                 arm64_ventura: "00dbff95e94aa2d00f733b6051ef1dbd2c3e7391af33abaf75c241420a7cd36f"
    sha256 cellar: :any,                 sonoma:        "83a80337d431781ad43754bd27ebbe0ed522fa212aba1741b7376d1b46468583"
    sha256 cellar: :any,                 ventura:       "eb7c7b3dd11ef2bf8c802748bf6c82df3e574425976a84e94348ea221432feb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d56fcfa410907d7cae43cd9dd5c127d10643845d935bcbc4a687f8851f8c704"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  conflicts_with "libtorrent-rasterbar", because: "they both use the same libname"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <string>
      #include <torrent/torrent.h>
      int main(int argc, char* argv[])
      {
        return strcmp(torrent::version(), argv[1]);
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-ltorrent"
    system "./test", version.to_s
  end
end
