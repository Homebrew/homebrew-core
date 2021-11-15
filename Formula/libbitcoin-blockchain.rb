class LibbitcoinBlockchain < Formula
  desc "Bitcoin Blockchain Library"
  homepage "https://github.com/libbitcoin/libbitcoin-blockchain"
  url "https://github.com/libbitcoin/libbitcoin-blockchain/archive/v3.6.0.tar.gz"
  sha256 "18c52ebda4148ab9e6dec62ee8c2d7826b60868f82710f21e40ff0131bc659e0"
  license "AGPL-3.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "8260a24f2d3450203db3386f0e0f6bcb857f045748992a7115679afee4285b96"
    sha256 cellar: :any,                 arm64_big_sur:  "b6c7eba40fc345969eda3c9c0aee34b4f2b460cece3e9c1110a9cc9d3ed4ad72"
    sha256 cellar: :any,                 monterey:       "70987037cd3e5af741f2c0eb39f6b3104226208147deb5548193a348c0cbf2f1"
    sha256 cellar: :any,                 big_sur:        "d68b78c0430f3610f43395bcf12633ab7fc037f3bc874b83fd456fa6a3cb38a6"
    sha256 cellar: :any,                 catalina:       "40ef8e8935d75f1c894852305b586fc922425467b6955813c2327d0ac901005f"
    sha256 cellar: :any,                 mojave:         "ce1a34b80aa5d9c404c27c2282bf1e654b48999e74e4facc4dff70bf8087a514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71dfd2b32aea36f35b7d57e6d166a23ef3f1eb383ab807705ab8eaa97dcbe121"
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
                          "--prefix=#{prefix}",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}"
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
