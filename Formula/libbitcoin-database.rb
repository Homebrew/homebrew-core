class LibbitcoinDatabase < Formula
  desc "Bitcoin High Performance Blockchain Database"
  homepage "https://github.com/libbitcoin/libbitcoin-database"
  url "https://github.com/libbitcoin/libbitcoin-database/archive/v3.4.0.tar.gz"
  sha256 "34ca5c11800ea8efb1ef986e83f5e4fcdde95e85d2406f0a7ed922725e45f0e0"

  bottle do
    sha256 "bd6e177feda0ca98e4b2972edfa1048220ffdbfa3f98945af9bab69ab33e7883" => :high_sierra
    sha256 "0115578ef6f9db710419ccc61f087b4db9a6e94693074f29d15309af97ef7625" => :sierra
    sha256 "8987f774562b107685acc81bdb77114aeaf0630950ac0c784e85909f6c3e59e8" => :el_capitan
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
