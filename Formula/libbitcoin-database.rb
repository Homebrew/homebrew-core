class LibbitcoinDatabase < Formula
  desc "Bitcoin High Performance Blockchain Database"
  homepage "https://github.com/libbitcoin/libbitcoin-database"
  url "https://github.com/libbitcoin/libbitcoin-database/archive/v3.6.0.tar.gz"
  sha256 "d65b35745091b93feed61c5665b5a07b404b578e2582640e93c1a01f6b746f5a"
  license "AGPL-3.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "60de0273aad1dd8e6cf5a6aee37e3e0259b04a80c9306531911aad1568f68f42"
    sha256 cellar: :any,                 arm64_big_sur:  "c1d506851f55d14f591199679e0d69194e0d5f3beb33661aa1f3039f1ac53ee8"
    sha256 cellar: :any,                 monterey:       "010d4a494803f0be8e9d4d3aa7aec51b6fb6d9604de00bc6b37a790b957484d6"
    sha256 cellar: :any,                 big_sur:        "f80eeb0824322169fb89bff9cd94dff0142380c35bd3e452fcf1e01174f955aa"
    sha256 cellar: :any,                 catalina:       "1acfc0d126ed7e1be41052065e8f47df77768d80caf16a6a51cbed22b1538e28"
    sha256 cellar: :any,                 mojave:         "4d4976669d9eb758689b8b5e55a31d2d9bd9b03e0422f67bcddb4fdd9a1009ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63d65785557d21b919ff49d95784070955161d0a8eb031f7e0562f57f31d5e81"
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
                          "--prefix=#{prefix}",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}"
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
