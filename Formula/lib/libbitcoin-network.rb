class LibbitcoinNetwork < Formula
  desc "Bitcoin P2P Network Library"
  homepage "https://github.com/libbitcoin/libbitcoin-network"
  url "https://github.com/libbitcoin/libbitcoin-network/archive/v3.8.0.tar.gz"
  sha256 "d317582bc6d00cba99a0ef01903a542c326c2a4262ef78a4aa682d3826fd14ad"
  license "AGPL-3.0"

  bottle do
    sha256                               arm64_ventura:  "cbc95be566837d05ab7081b500cbc521d3b635bef0f150e7fb3b24b3fd26ba81"
    sha256                               arm64_monterey: "02e031e34b6c771fb2cac826085dc60d953dd262ba6578e6c5d3ccbfc73b649f"
    sha256                               arm64_big_sur:  "1ee99f15c6ba15a72de2b2f5a079dda7103560790db0e74e340c70142d73d7bd"
    sha256                               ventura:        "c0e8bb5b9e3fce3536bfdd9c27544418a85941ae4f4a5e568f9867973de02844"
    sha256                               monterey:       "00447d5fde3d101c2e8615bd57541c43dfd6072c74d9043e2de1ff369977b7bf"
    sha256                               big_sur:        "d29b438439b131210afe2463c653758021f3d511312c508175dc8c7be63be4cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85a1025a8f1de1b638c7ebe3f7c57c0bf4d4b40b313198aa9bc816aeff1cf2d9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  # https://github.com/libbitcoin/libbitcoin-system/issues/1234
  depends_on "boost@1.76"
  depends_on "libbitcoin"

  def install
    ENV.cxx11
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost-libdir=#{Formula["boost@1.76"].opt_lib}"
    system "make", "install"
  end

  test do
    boost = Formula["boost@1.76"]
    (testpath/"test.cpp").write <<~EOS
      #include <bitcoin/network.hpp>
      int main() {
        const bc::network::settings configuration;
        bc::network::p2p network(configuration);
        assert(network.top_block().height() == 0);
        assert(network.top_block().hash() == bc::null_hash);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-I#{boost.include}",
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin-system",
                    "-L#{lib}", "-lbitcoin-network",
                    "-L#{boost.lib}", "-lboost_system"
    system "./test"
  end
end
