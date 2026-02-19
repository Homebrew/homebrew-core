class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.6.tar.gz"
  sha256 "720ff411ef0627a928141cad7f60b171a2fc44fb8700b0914e0072eab1a7be1b"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "32f199169d09f60740c6b495534ef0ec45f493d38a4209179848ea4455355742"
    sha256 cellar: :any,                 arm64_sequoia: "14aeb86e15ba1cc8316fd2d734b876fe93a29c3a3f8206eb0edfd66c02f341cf"
    sha256 cellar: :any,                 arm64_sonoma:  "45ec40e48b21cd1ff1a7b6149ea1552ff9b826fca58a5e49411dabb09b88d1ca"
    sha256 cellar: :any,                 sonoma:        "048e234f7bd34d5b022b0d88bb9e454912d82bb1d6f9b16483a7973433992a2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "182c7dca98244fb607648b1c30c968a3869052b6e1b964cad6da9cc1ef88859f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b57703654e39e6c55e7210679e621cd01c5969056af7018ee748dc3455ff27f"
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
