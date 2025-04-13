class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "045cfc796579dd08445745c3cd38427004202eaa7529d349e482c2b67f3b52b0"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "92944a37d1e98a24565907c46582ea254e24d19c6b80d5de850d3dfeb4651b0c"
    sha256 cellar: :any,                 arm64_sonoma:  "0bfddf1f1a2f9b6d03bf6ad34888f52898fc4dafaece5d4b1535b5a088d3fedd"
    sha256 cellar: :any,                 arm64_ventura: "b98b63b07ebfb1ec35648bdb1932be3aa361479ff45cd8f341c0708bc3582271"
    sha256 cellar: :any,                 sonoma:        "97a132cfb410a50a6df4f3a9ab8dcb47177974f47adbd1278eafd829e6a8fbaa"
    sha256 cellar: :any,                 ventura:       "7dce7190e447669a73826851ee076a800a7e7c66e7e277bf5fde6ab94bf7470d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f7a0c7ae145dccc63017de91b5fe283cad6013092979170b289b2c597f27af0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88789a90d564aeded31c70b421c6c5917fceea4b84f42358fca866c7bc8b20b1"
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
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-L#{lib}", "-ltorrent"
    system "./test", version.to_s
  end
end
