class LibbitcoinBlockchain < Formula
  desc "Bitcoin Blockchain Library"
  homepage "https://github.com/libbitcoin/libbitcoin-blockchain"
  url "https://github.com/libbitcoin/libbitcoin-blockchain/archive/v3.5.0.tar.gz"
  sha256 "03b8362c9172edbeb1e5970c996405cd2738e8274ba459e9b85359d6b838de20"
  revision 1

  bottle do
    sha256 "0063d8b112d2203e716ffcd109e302c2f9ef29bbbcf621d3328543a5663da8f1" => :mojave
    sha256 "aa13f881333257abe5d81861261b6b59bde9cadcdd0a8bf10a76d92c816585dd" => :high_sierra
    sha256 "d5e38924d17be27ff630448796d7ad8177da000756375f06c384163979334a6f" => :sierra
    sha256 "57b5d4faa0d88847c78c13dc91c56d1daca55029e121aca0b369580a4ca5ee69" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin-consensus"
  depends_on "libbitcoin-database"

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
      #include <bitcoin/blockchain.hpp>
      int main() {
        static const auto default_block_hash = libbitcoin::hash_literal("14508459b221041eab257d2baaa7459775ba748246c8403609eb708f0e57e74b");
        const auto block = std::make_shared<const libbitcoin::message::block>();
        libbitcoin::blockchain::block_entry instance(block);
        assert(instance.block() == block);
        assert(instance.hash() == default_block_hash);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-I#{libexec}/include",
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin",
                    "-L#{lib}", "-L#{libexec}/lib", "-lbitcoin-blockchain",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_system"
    system "./test"
  end
end
