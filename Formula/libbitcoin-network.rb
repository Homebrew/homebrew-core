class LibbitcoinNetwork < Formula
  desc "Bitcoin P2P Network Library"
  homepage "https://github.com/libbitcoin/libbitcoin-network"
  url "https://github.com/libbitcoin/libbitcoin-network/archive/v3.6.0.tar.gz"
  sha256 "68d36577d44f7319280c446a5327a072eb20749dfa859c0e1ac768304c9dd93a"
  revision 1

  bottle do
    cellar :any
    sha256 "7cfd1e7d27efaa5a097c5b9b3a7560504a9b25cb5b65b1d9111ac8312fe16656" => :catalina
    sha256 "8e4f39b82eb02eaba960d02dd78783e70dbe190566e3b978d4000c95f3b211d8" => :mojave
    sha256 "4f641ea3e82b0ec336172a3cfb87f4cc5750390f57fcd73fd15c85cbf6a5356f" => :high_sierra
    sha256 "4619c4f9515111e430c671fd580fdf5c8547a75b82d1ea88ae6c2e250446c242" => :sierra
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
                          "--prefix=#{prefix}"
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
