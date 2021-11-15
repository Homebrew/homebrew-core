class LibbitcoinNetwork < Formula
  desc "Bitcoin P2P Network Library"
  homepage "https://github.com/libbitcoin/libbitcoin-network"
  url "https://github.com/libbitcoin/libbitcoin-network/archive/v3.6.0.tar.gz"
  sha256 "68d36577d44f7319280c446a5327a072eb20749dfa859c0e1ac768304c9dd93a"
  license "AGPL-3.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f3793425b364b897fc7916d488a7645f735dc385edd645beb96e6b5681891ea8"
    sha256 cellar: :any,                 arm64_big_sur:  "424e25564e199005eb3944f8e682ac6c07803833494b9b89df2175e93b7ba34b"
    sha256 cellar: :any,                 monterey:       "7c51f436a31f94b18ca3d462c5797b7bf9fb63e1dabcbfdcc77f881a61ffe923"
    sha256 cellar: :any,                 big_sur:        "21053287aadad7716c0b0471778e8b88d542d8b8628e505f917ffd20f8ebe78c"
    sha256 cellar: :any,                 catalina:       "6ab4e56e5f996fe7441564b5998b4bd7ef7350fb6cfc5dda22b0efd55d64ef80"
    sha256 cellar: :any,                 mojave:         "3f856ae06429e04d02fafefd40ad3ec6732f0b644e126fc3f5f3d42ad92c7e2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ab35bf2bc8d91ab8cdb61a68883fa383676acf5088851a8affae7962175bd9a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin"

  def install
    ENV.cxx11
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}"
    system "make", "install"
  end

  test do
    boost = Formula["boost"]
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
                    "-L#{boost.opt_lib}", "-lboost_system"
    system "./test"
  end
end
