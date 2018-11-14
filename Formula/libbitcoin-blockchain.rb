class LibbitcoinBlockchain < Formula
  desc "Bitcoin Blockchain Library"
  homepage "https://github.com/libbitcoin/libbitcoin-blockchain"
  url "https://github.com/libbitcoin/libbitcoin-blockchain/archive/v3.5.0.tar.gz"
  sha256 "03b8362c9172edbeb1e5970c996405cd2738e8274ba459e9b85359d6b838de20"
  revision 2

  bottle do
    sha256 "13d5adb31936d5aef918c27e15c482bce6219e2a7ba78b8866c1867b06caeb77" => :mojave
    sha256 "9d300f4136435b9331943acc70cab877bd9db1ccc24be1c71a6a23908748ee90" => :high_sierra
    sha256 "ef052aa668a26246c2d8dae460b56e91d7bc1467c0f8b7b61f5eca23f7e6d97c" => :sierra
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
