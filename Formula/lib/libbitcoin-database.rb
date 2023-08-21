class LibbitcoinDatabase < Formula
  desc "Bitcoin High Performance Blockchain Database"
  homepage "https://github.com/libbitcoin/libbitcoin-database"
  url "https://github.com/libbitcoin/libbitcoin-database/archive/v3.8.0.tar.gz"
  sha256 "37dba4c01515fba82be125d604bbe55dbdcc69e41d41f8cf6fbaddaaab68c038"
  license "AGPL-3.0"

  bottle do
    sha256                               arm64_ventura:  "085d60b4ff75bcb02c2c24f8b36e12a6804587823d7bce47c87a2ce365aeee93"
    sha256                               arm64_monterey: "416b1796141562f505e4cef82d423aaa82922f7db1e92a6039eb703a926953e9"
    sha256                               arm64_big_sur:  "d056274486cfd0408410dbafe9d4b8cbdbb4f128036d3caaa424c819b1f04d1c"
    sha256                               ventura:        "a51a5727890ec061d0d4c2f67adc2294ec146dc544c6f84686f44d6ba90fb29c"
    sha256                               monterey:       "0452a192afca88622e417a0b60864cb9ad6ebcea150a8ce6766352c407b7bcac"
    sha256                               big_sur:        "35add1b0342d29324119da89d480cf3b7223caa2e17e9eac6d5a64f488ed78d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a161a74fde168d8846a2e1dd96667ccff1637df3053ef2d5927c629b457b89a"
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
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin-system",
                    "-L#{lib}", "-lbitcoin-database",
                    "-L#{boost.lib}", "-lboost_system"
    system "./test"
  end
end
