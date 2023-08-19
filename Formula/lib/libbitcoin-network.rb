class LibbitcoinNetwork < Formula
  desc "Bitcoin P2P Network Library"
  homepage "https://github.com/libbitcoin/libbitcoin-network"
  url "https://github.com/libbitcoin/libbitcoin-network/archive/v3.6.0.tar.gz"
  sha256 "68d36577d44f7319280c446a5327a072eb20749dfa859c0e1ac768304c9dd93a"
  license "AGPL-3.0"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cd323975746858b489ae833a30eb349d370c7255b449967bd8cc92ba082b62b4"
    sha256 cellar: :any,                 arm64_monterey: "f63e59fce512e4075d886ca920977a340092a06ca6a77a4a30a3e29487f30af1"
    sha256 cellar: :any,                 arm64_big_sur:  "d5b25de58273e7a75f3ab79ec9b191b01bebdf9901a3345ff2e9a1df23ba0bad"
    sha256 cellar: :any,                 ventura:        "f66175668b2ba698a69a78a1eefbd3a35b801be55d715e012a97faca572bc652"
    sha256 cellar: :any,                 monterey:       "7a342860fe4bc338f783efd3f1d1f7dee8247c5aed93f313c679ac02c3a09b9a"
    sha256 cellar: :any,                 big_sur:        "afb63dab758788b425675d7e6920c74259e682c7a8e67ebe3c47016b715e70b2"
    sha256 cellar: :any,                 catalina:       "7ace1c57a1959c1dbbf2fe3dfe468dc5f5ffb37944bc21ad7f817df308b7d661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b6f7ca20b8d9bfd7599d1358f9b38458f247120a2ccd6d3ef1f082de188fd21"
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
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin",
                    "-L#{lib}", "-lbitcoin-network",
                    "-L#{boost.lib}", "-lboost_system"
    system "./test"
  end
end
