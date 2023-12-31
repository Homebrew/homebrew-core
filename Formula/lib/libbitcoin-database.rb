class LibbitcoinDatabase < Formula
  desc "Bitcoin High Performance Blockchain Database"
  homepage "https://github.com/libbitcoin/libbitcoin-database"
  url "https://github.com/libbitcoin/libbitcoin-database/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "37dba4c01515fba82be125d604bbe55dbdcc69e41d41f8cf6fbaddaaab68c038"
  license "AGPL-3.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7d1a6883674ad006e2233445adc8c47ef8505acdb097ce666bb91e83b4e38e1c"
    sha256                               arm64_ventura:  "d5aaf977086d6ae540c4726ce77eed25538d1bcba722d34d69dfefa42a531600"
    sha256                               arm64_monterey: "f238610033ae744928597b0719dd7eb2347e5470ebd23c81638cac3d9368799a"
    sha256                               arm64_big_sur:  "ffb0d03c1e8a283039a15e3ca8f5d4dcac8b394146658803e512960f655d9f87"
    sha256 cellar: :any,                 sonoma:         "81f2ed2a08808be901616743e9ab7b9b22969af3fe2e038b08502c48b2dc4d49"
    sha256                               ventura:        "cdd90d1627d1371f7c4fcd5c31419ca884ce5b39ce139180a285a206415f0da5"
    sha256                               monterey:       "df0d64f7244474c78af515e30944fd727b3c2565e8a2aae7d2db32e8b06b7dbe"
    sha256                               big_sur:        "035abb92965ca29b24b7ebaace65626c803e8c7a5771debfbb011d5460de6a73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f2ceee2a4bc6ac4b0b67af2b97916eb79e0ed1aeee66a4a8695beee59e44a50"
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
  depends_on "libbitcoin-system"

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
