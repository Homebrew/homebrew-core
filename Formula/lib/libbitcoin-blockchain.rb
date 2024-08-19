class LibbitcoinBlockchain < Formula
  desc "Bitcoin Blockchain Library"
  homepage "https://github.com/libbitcoin/libbitcoin-blockchain"
  url "https://github.com/libbitcoin/libbitcoin-blockchain/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "e7a3f2d2ea8275946218d734cd3d5d805c61e69eb29d1fb16e3064554bd2b584"
  license "AGPL-3.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "98b05bbaaa471ed07081871007711a310f4d3cadcde0fd6ac7390f89d4fb4f1d"
    sha256                               arm64_ventura:  "643036ef5fdad2d2686dfd0e943e7427f2921a679ca6b65dc2d7520702f607b6"
    sha256                               arm64_monterey: "87003f5fe6734526014672e39ffa2e9654962fa068aff56fac817b31b1191b47"
    sha256                               arm64_big_sur:  "b578deb82d92c0a638e03b3c275550235ae86b4124ffd0ad80b080cbfcde9268"
    sha256 cellar: :any,                 sonoma:         "2ae4f59b8adc73b1f5b8c74dc1213bfe712de9d8560d339222c815366d10a3cc"
    sha256                               ventura:        "2442e4da6b10806fe090df445baf70eb1b8fc02402af7bfe0381b116cdc5da47"
    sha256                               monterey:       "e41010dcffc1263b452d253b58ab955fff3d117621d28d600b1095e42d0ef564"
    sha256                               big_sur:        "1098628c8c88b9ab9b82188e9b048d442080242c1b77766b474eaf405765d8fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f806a8129d3d225515cb2c5c789f29c26b756df83e4ea3139f3baddd353a288"
  end

  # About 2 years since request for release with support for recent `boost`.
  # Ref: https://github.com/libbitcoin/libbitcoin-system/issues/1234
  deprecate! date: "2023-12-14", because: "uses deprecated `boost@1.76`"

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
