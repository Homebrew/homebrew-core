class LibbitcoinNetwork < Formula
  desc "Bitcoin P2P Network Library"
  homepage "https://github.com/libbitcoin/libbitcoin-network"
  url "https://github.com/libbitcoin/libbitcoin-network/archive/v3.5.0.tar.gz"
  sha256 "e065bd95f64ad5d7b0f882e8759f6b0f81a5fb08f7e971d80f3592a1b5aa8db4"
  revision 1

  bottle do
    sha256 "25cdc75678d929d2306397fea58dd75015c1ecebe42813b8b55777784d47b951" => :mojave
    sha256 "928ea0512c134bbff8004812c0681e742db1af2d0b98c72d8b046c01cf7849cd" => :high_sierra
    sha256 "061fd0b2d89dc373a61410c3d7a9dc401b14d12f17584250ce03aaa392f0d66f" => :sierra
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
