class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/v0.13.8.tar.gz"
  sha256 "0f6c2e7ffd3a1723ab47fdac785ec40f85c0a5b5a42c1d002272205b988be722"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5ccfa09c2d94c64c6b679207321aed2117f29aaec554d19eb8331c8027047145"
    sha256 cellar: :any,                 arm64_monterey: "8f1a7a4a2338a09c9f5f39cb1b716bdb3dbeb33f44c7d702da166625f786a1b1"
    sha256 cellar: :any,                 arm64_big_sur:  "ca9bea66ac7157a5bf98b1a9fb57c8415a0d230e92a2bcdef606b0ff4deeb8eb"
    sha256 cellar: :any,                 ventura:        "c6833f403509071a11728d6610ea4a5532e01ff5e6dc333ec7a9ffe9928206dc"
    sha256 cellar: :any,                 monterey:       "53bc7e0d421ae9dec53ef1c05cbfb3d77ef2ab8aa05cd6c528ef7768a7d3d436"
    sha256 cellar: :any,                 big_sur:        "822e53a729fa75e02538b8f40cbeeb3248b91b6dd65e31ce809859a17ff3995c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5adf01ed7294438a577a291f0ae4498aa2261e04317629ad5affe21021df8aa4"
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
