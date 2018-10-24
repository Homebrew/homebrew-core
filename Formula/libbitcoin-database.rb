class LibbitcoinDatabase < Formula
  desc "Bitcoin High Performance Blockchain Database"
  homepage "https://github.com/libbitcoin/libbitcoin-database"
  url "https://github.com/libbitcoin/libbitcoin-database/archive/v3.5.0.tar.gz"
  sha256 "376ab5abd8d7734a8b678030b9e997c4b1922e422f6e0a185d7daa3eb251db93"
  revision 1

  bottle do
    sha256 "090ad1d4f6367373c1281d2c90fdc8f49578838c2287b0ec623eefa4f35cbc88" => :mojave
    sha256 "5f5132764497e84c336da0facabf75b902fcf7c90b61174f91e700c212d2060a" => :high_sierra
    sha256 "fdd4829c6ef22a8e971923425d81ecd97820607a91131e05115ae077010de3e7" => :sierra
    sha256 "ebc1fbfc2da1b6420117dbe3035bdf7a5cce94cf868aa68b75ce3cdf84c912b0" => :el_capitan
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
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin",
                    "-L#{lib}", "-lbitcoin-database",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_system"
    system "./test"
  end
end
