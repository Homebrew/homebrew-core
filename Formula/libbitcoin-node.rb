class LibbitcoinNode < Formula
  desc "Bitcoin Full Node"
  homepage "https://github.com/libbitcoin/libbitcoin-node"
  url "https://github.com/libbitcoin/libbitcoin-node/archive/v3.5.0.tar.gz"
  sha256 "e3a0a96155ca93aa6cba75789c18419f40686a69cbd40c77aa77ca84ccc43cab"
  revision 1

  bottle do
    sha256 "752a5c48f26edfba5d7684c25b25d9329efb91ce2875d368c62da19e3e8556b5" => :mojave
    sha256 "f2798e9c9fbd9e2ea2bbbb7233965bb50d02a96e90b2ef87c57a7c8bf0917752" => :high_sierra
    sha256 "7405c42f379048caada917eead1e620d9fe7683c8d6ce96f59fd0699d90bed54" => :sierra
    sha256 "62977c7dbcd04d4c4bc1c50a64f5e10ac20ae36fb9eff7f2ac34acb97259bad3" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin-blockchain"
  depends_on "libbitcoin-network"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    bash_completion.install "data/bn"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <bitcoin/node.hpp>
      int main() {
        libbitcoin::node::settings configuration;
        assert(configuration.sync_peers == 0u);
        assert(configuration.sync_timeout_seconds == 5u);
        assert(configuration.refresh_transactions == true);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp",
                    "-I#{libexec}/include",
                    "-lbitcoin", "-lbitcoin-node", "-lboost_system",
                    "-o", "test"
    system "./test"
  end
end
