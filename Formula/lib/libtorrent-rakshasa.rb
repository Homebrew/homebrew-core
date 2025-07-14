class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.15.5.tar.gz"
  sha256 "e3c1728c3dba615424db0b7e6ade105a9c041d02b8f5c8443ada06e50d21ed46"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7a7ded1ee559d96a35d6a034a82ecb2ac1e002e9b54ce1f5e39c20a6d940d8f3"
    sha256 cellar: :any,                 arm64_sonoma:  "8aecbef90659d95d360f7e22e7f58738ed5ca781e4717a1df82e76db75672f32"
    sha256 cellar: :any,                 arm64_ventura: "e63c2537db1a67009a4aeddb38686953265acf417c6a9175a87b20f512ea49ec"
    sha256 cellar: :any,                 sonoma:        "52006abd3981cf21252cfb006cc7203cfc23e9ab9ec644ef1b013f26a1bc6785"
    sha256 cellar: :any,                 ventura:       "90ee9ae0a637fbe981b0fde0a23d5edc280c8122e1406aa2546698a752d5196f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c60eff13d22cccb2327dad4cb1c1299f6eea2da927465286c825ee7d0743a407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc137bfcedc79f3170dbcaa7fe34f3f47b50ec97a15a825c4ab5a367a97fed08"
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
