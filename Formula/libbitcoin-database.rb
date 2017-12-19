class LibbitcoinDatabase < Formula
  desc "Bitcoin High Performance Blockchain Database"
  homepage "https://github.com/libbitcoin/libbitcoin-database"
  url "https://github.com/libbitcoin/libbitcoin-database/archive/v3.4.0.tar.gz"
  sha256 "34ca5c11800ea8efb1ef986e83f5e4fcdde95e85d2406f0a7ed922725e45f0e0"
  revision 1

  bottle do
    sha256 "48a7e38d29b4dd9d9df2a671da3fbb3696e930bda4c9e54bc78f16678eb2da4d" => :high_sierra
    sha256 "a3da58716e72b0caecf464280d0cad30add26ae0e1a7c62e9d5a7a9dbfba887d" => :sierra
    sha256 "8ab5df1d14182c59f56805b5e968a065743249829eaaa7638e49161860c7614a" => :el_capitan
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
    system ENV.cxx, "-std=c++11", "test.cpp",
                    "-lbitcoin", "-lbitcoin-database", "-lboost_system",
                    "-o", "test"
    system "./test"
  end
end
