class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.17.tar.gz"
  sha256 "14b502a00f0eeebee9293f7c6cf0d3ec356a5a3792c0d320290edd19c7a65d0b"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "30357a5d2c350b38ab0ad1346d9ae58f5b2650759de839b1e2bc8053841df960"
    sha256 cellar: :any, arm64_sequoia: "1d7fa2c69da2beb7963e82eaced74e0a3b9ca8a5bc419c5cd300872bd7c4bae3"
    sha256 cellar: :any, arm64_sonoma:  "7f072ee0a6df1f13f5d233f8e90ac8b021a426ac815eaf737baa00a576f20e7c"
    sha256 cellar: :any, sonoma:        "6604c4f396ffc61a757e49bac5cee2dc4355ab184b35900cb6bc6a8c4efa94dc"
    sha256 cellar: :any, arm64_linux:   "7ba2efdb50fc48ae75bf66a6f7a0291f1603bd3fc222efdbd5f644ba9b869a40"
    sha256 cellar: :any, x86_64_linux:  "b5e137979eb768823375f705b5592fd4c8be2195d1de581f761d5a2a2367f6c5"
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
