class LibbitcoinNetwork < Formula
  desc "Bitcoin P2P Network Library"
  homepage "https://github.com/libbitcoin/libbitcoin-network"
  url "https://github.com/libbitcoin/libbitcoin-network/archive/v3.5.0.tar.gz"
  sha256 "e065bd95f64ad5d7b0f882e8759f6b0f81a5fb08f7e971d80f3592a1b5aa8db4"

  bottle do
    sha256 "57181b12da719b610445c4533f20868bc0272e65476dd4c944658455e88038fc" => :mojave
    sha256 "84059bf2b3557d112a30d5cee534c60c2e852a34ec65bd3e847ef88b118802f0" => :high_sierra
    sha256 "34f9af49bdbfb835bd917e92aa24aef2a129c587a44188f711c278ed9009eeec" => :sierra
    sha256 "d83849347ad9b982027380b3777371d9d3703ac9577dc3f2b8abe44a4e3cfdbf" => :el_capitan
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
