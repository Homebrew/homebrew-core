class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "e63f8cef2fef8dfe1e147f21d4148206d29639f63788c98fdb49f58318d71ada"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "98264f5867242371dfb2dc18314db6df347f65b2ec2798ada584e078b04c650a"
    sha256 cellar: :any,                 arm64_sequoia: "a591cf356914b542d2d969f4c5ef751503daa222efb83c76dc0816828c1f0c71"
    sha256 cellar: :any,                 arm64_sonoma:  "edaa94710668dff8437f7211a8117de2592ab8bc03093510cc174adb4198413f"
    sha256 cellar: :any,                 sonoma:        "ca6b51b289799bc49dd49863808b83f49983b8c6a38d9223c9521b8cb23d234a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e51f9a1aba1f3ba994cd24cce0907c729380616f9494298eb802e6b5b2f43b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c208f276ee0b03738fd1471ef3e2d6fae5191632d294a2c85ea7108192fd4534"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  conflicts_with "libtorrent-rasterbar", because: "both use the same libname"

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
