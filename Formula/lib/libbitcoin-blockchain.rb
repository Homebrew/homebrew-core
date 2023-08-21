class LibbitcoinBlockchain < Formula
  desc "Bitcoin Blockchain Library"
  homepage "https://github.com/libbitcoin/libbitcoin-blockchain"
  url "https://github.com/libbitcoin/libbitcoin-blockchain/archive/v3.8.0.tar.gz"
  sha256 "e7a3f2d2ea8275946218d734cd3d5d805c61e69eb29d1fb16e3064554bd2b584"
  license "AGPL-3.0"

  bottle do
    sha256                               arm64_ventura:  "afa7ce1350b814247298e7ded5f6e73c9656d06076207bf334f53c5d9e0f106f"
    sha256                               arm64_monterey: "de135045d1b91c2091c49a3db2ef17cb2da1730a8a5951ec07e01b00d8dd13d8"
    sha256                               arm64_big_sur:  "42a7f74478b2c51f134308e28ab4b8c68d702f80fe63f29b2249592172ca94bd"
    sha256                               ventura:        "6557ae872316db8677cd179e96173ebd085ff0c423ab9f1ed9b617b152228264"
    sha256                               monterey:       "64887449b66a9435d94227b2d26ead978799b6f7cb83aa659e457ed5d68025ee"
    sha256                               big_sur:        "a2a4b0f81e71389ae3981f6468fe26718d397c3052144caccd49a8a073de01d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f75dfb68e40960b2238997b568cbbae18541f556ea727ab7b5797750e051c9eb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  # https://github.com/libbitcoin/libbitcoin-system/issues/1234
  depends_on "boost@1.76"
  depends_on "libbitcoin-consensus"
  depends_on "libbitcoin-database"

  def install
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
                    "-I#{boost.include}",
                    "-I#{libexec}/include",
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin-system",
                    "-L#{lib}", "-L#{libexec}/lib", "-lbitcoin-blockchain",
                    "-L#{boost.lib}", "-lboost_system"
    system "./test"
  end
end
