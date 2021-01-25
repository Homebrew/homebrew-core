class LibbitcoinNetwork < Formula
  desc "Bitcoin P2P Network Library"
  homepage "https://github.com/libbitcoin/libbitcoin-network"
  url "https://github.com/libbitcoin/libbitcoin-network/archive/v3.6.0.tar.gz"
  sha256 "68d36577d44f7319280c446a5327a072eb20749dfa859c0e1ac768304c9dd93a"
  license "AGPL-3.0"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "e760abf225587423f5ed0891c8a9a330f1173f7608cfa1906204f47b67c65b7f" => :big_sur
    sha256 "e63ef024520036e35dd879481873a53e29b97c7c86f643811f78ea473ae7e5d6" => :arm64_big_sur
    sha256 "cd94e02e3062f2983c30d1e275407ffcabb4981df0e92d2774022ac3cb020e47" => :catalina
    sha256 "48f9eb92dcbd19a0efc978e0c844152b5712c5861e6f04ca92023d04d6b6c538" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}"
    system "make", "install"
  end

  test do
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
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin",
                    "-L#{lib}", "-lbitcoin-network",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_system"
    system "./test"
  end
end
