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
    sha256 cellar: :any,                 arm64_tahoe:   "224396746f0270c596c1ef9627aaddc8536343f610d733172ede785f995676d8"
    sha256 cellar: :any,                 arm64_sequoia: "7fc34274e145db980ed8e5055be7b4b81c5ec89f5c2ea4f31f4ac5fe929c5397"
    sha256 cellar: :any,                 arm64_sonoma:  "753a34d3b2231c11d89da6e22025b26aebb535752420deed00471480d2cd9f50"
    sha256 cellar: :any,                 sonoma:        "6f1b4093c3912a4b89fcf83cc794bd857d4dd68abb01eb4040f4223050afdb7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54165fb0cde133016dcae15efa7933e5aeb18002f07d2349bf3e4954d06b0105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c72ea44910be342bf57a858b69e9644d82e84def3a2a81dd3d696f0965326d6e"
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
