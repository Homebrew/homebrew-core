class LibbitcoinDatabase < Formula
  desc "Bitcoin High Performance Blockchain Database"
  homepage "https://github.com/libbitcoin/libbitcoin-database"
  url "https://github.com/libbitcoin/libbitcoin-database/archive/v3.6.0.tar.gz"
  sha256 "d65b35745091b93feed61c5665b5a07b404b578e2582640e93c1a01f6b746f5a"
  license "AGPL-3.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9f3a1b14cec14874e96aa73c538552536c758eedf762336d445bed0e2e1a1c49"
    sha256 cellar: :any,                 arm64_monterey: "085dd23364eb6643233052da9c14e3e8cbfa99d22588c2febc0335cb99f26eab"
    sha256 cellar: :any,                 arm64_big_sur:  "8cfc5dcf5ad3e74e38f2887b2d2fffcca747981096a5ddacafbe3fe882f371e1"
    sha256 cellar: :any,                 ventura:        "487a2131b39e783252329f3c8c38c0cf97b74688cad7d65a2d0c1e4d58a878d8"
    sha256 cellar: :any,                 monterey:       "d280b0babbd6de733c4850196c62b48096a6eb8e9c0fc14fd750614d4bbcc6e9"
    sha256 cellar: :any,                 big_sur:        "bfdabb34fb0d87a5e04dad70a325dd9bbab3c184cfe0657a43c6aa8ebdc6a6a8"
    sha256 cellar: :any,                 catalina:       "eb6c6550f0e853c7c175c550654e7a095bb5306da305969902d888b5c412bc21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "552bedf49b5667b5d3d79486021d114623c7e9df0a6d9d84d3d9c0e019e5d8fe"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  # https://github.com/libbitcoin/libbitcoin-system/issues/1234
  depends_on "boost@1.76"
  depends_on "libbitcoin"

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
      #include <bitcoin/database.hpp>
      using namespace libbitcoin::database;
      using namespace libbitcoin::chain;
      int main() {
        static const transaction tx{ 0, 0, input::list{}, output::list{ output{} } };
        unspent_outputs cache(42);
        cache.add(tx, 0, 0, false);
        assert(cache.size() == 1u);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-I#{boost.include}",
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin",
                    "-L#{lib}", "-lbitcoin-database",
                    "-L#{boost.lib}", "-lboost_system"
    system "./test"
  end
end
