class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.22.tar.gz"
  sha256 "1fc0e071a4d8f5521a70c394330d71bd79ce6318490323b29093766bc2a683de"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dc3bc28cc28416e2103d06d14daabbff8ae264fbc5a21020eb10073cb1c21b8b"
    sha256 cellar: :any, arm64_sequoia: "1aa844048474d6a662a7784288463789139301b45757ff46144308eb1e9e1f20"
    sha256 cellar: :any, arm64_sonoma:  "20ac1cea27c940c6c10d4587a2308c455d36d6c5468a215e3992606322da674a"
    sha256 cellar: :any, arm64_linux:   "fbf606f46eaf10b1a596a3c1d5d2b6e3e20a4b84b06ddb9a585f34d264532c16"
    sha256 cellar: :any, x86_64_linux:  "7a4811611b3e3417fefedae8b4ba055b86e947b86426fee61eef9c6b27ce8d03"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
      #include <torrent/runtime/runtime.h>
      int main(void)
      {
        std::cout << torrent::runtime::version() << std::endl;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-L#{lib}", "-ltorrent"
    assert_match version.to_s, shell_output("./test").strip
  end
end
