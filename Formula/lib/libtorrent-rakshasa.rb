class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "065ad92f861e170296e5b75771e999c9f6112a368a9600771c405a56ff6d15ea"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5ebc5614ba838ec31f4d392de58a7df77a3abe73c221285fdc915945bfcedd09"
    sha256 cellar: :any,                 arm64_sonoma:  "3e35a23486cb3fe45569ae82c2032a0365d6d1199f223669565b7956b697eac1"
    sha256 cellar: :any,                 arm64_ventura: "80a6138bca40845b6e135a7982439335c43da8c57086641ccc0d3420fa15ef68"
    sha256 cellar: :any,                 sonoma:        "c5e97092f4f77bf828d1dd229ee72f83d2012b3f9297156ea82515ecac710d37"
    sha256 cellar: :any,                 ventura:       "ff53d4ca1bc2d4ca615a098cc13b7be5647460a36703e907d5f2189d09349677"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bb6d1392271938fa329797d503afd79e0da0b4bdc2f212d8d42d376f7cb3d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cbede6223cedf70fb2b9a527df013e704a35fe673773007d7b0ffd5dd704331"
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
      #include <iostream>#{"  "}
      #include <torrent/torrent.h>
      int main(void)
      {
        std::cout << torrent::version() << std::endl;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-L#{lib}", "-ltorrent"
    assert_match version.to_s, shell_output("./test").strip
  end
end
