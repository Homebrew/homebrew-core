class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.27.tar.gz"
  sha256 "dfef062965b1675e3c21663898eefa31ef18a8bf80c0ab872735c0bf89c4035c"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c66a81cf2e96e706fb23259104c3b65ea9486be89ca8e81511a162fbae2c2605"
    sha256 cellar: :any, arm64_tahoe:       "05f0e9906e394bef7c823fc3901ea57d4c2ad9e5d81afa2c5744910465380530"
    sha256 cellar: :any, arm64_sequoia:     "ef3b0e256c55ef8da65e75df6d066ae02ca0e43d52c54e3b4824283f184cfaf0"
    sha256 cellar: :any, arm64_linux:       "b0590ac5b3917b390356e91f53dfcbc9d07d51c785a05e305e33a9be146ea048"
    sha256 cellar: :any, x86_64_linux:      "972d1c5b23fd12db79dbce051636598d010f50e17165d8f85f3ec223300263bd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "libtorrent-rasterbar", because: "both use the same libname"

  deny_network_access!

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
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
