class Libbitcoin < Formula
  desc "Bitcoin Cross-Platform C++ Development Toolkit"
  homepage "https://github.com/libbitcoin/libbitcoin-system"
  url "https://github.com/libbitcoin/libbitcoin-system/archive/v3.6.0.tar.gz"
  sha256 "5bcc4c31b53acbc9c0d151ace95d684909db4bf946f8d724f76c711934c6775c"
  license "AGPL-3.0"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "aa0010d9d93ce5d072a726f9cd997d256d20e29a60b2e785c20fecf7fd372ec6"
    sha256 cellar: :any,                 arm64_big_sur:  "2599894cb2129c474077e7a76a0abf45a9eb328f6dbf8da16946c19781d1ee6b"
    sha256 cellar: :any,                 monterey:       "1bcd7cf3e6541f1cefef4fd7de2c7e30d49f2c26adcc096b6c861ce1fd85aa0e"
    sha256 cellar: :any,                 big_sur:        "1244b027fc18f6dba8a0126a578165a09b1c01b1ebf87cba093f7a90b5083505"
    sha256 cellar: :any,                 catalina:       "3229377e4e17745fff4d608d41397c786f6772574bc4957f999cb3bf693e4d4b"
    sha256 cellar: :any,                 mojave:         "c17b574fa866c922c770dd70c9e08f5d55f2e24d5fabe5c366ffcf68f9bea946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9584040cd459dca7dc4e830b4f2b854f9e881dc57d5d8cba2da6df1c51a63dbe"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libpng"
  depends_on "qrencode"

  resource "secp256k1" do
    url "https://github.com/libbitcoin/secp256k1/archive/v0.1.0.13.tar.gz"
    sha256 "9e48dbc88d0fb5646d40ea12df9375c577f0e77525e49833fb744d3c2a69e727"
  end

  def install
    ENV.cxx11
    resource("secp256k1").stage do
      system "./autogen.sh"
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}",
                            "--enable-module-recovery",
                            "--with-bignum=no"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", "#{libexec}/lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "--with-png",
                          "--with-qrencode"
    system "make", "install"
  end

  test do
    boost = Formula["boost"]
    (testpath/"test.cpp").write <<~EOS
      #include <bitcoin/bitcoin.hpp>
      int main() {
        const auto block = bc::chain::block::genesis_mainnet();
        const auto& tx = block.transactions().front();
        const auto& input = tx.inputs().front();
        const auto script = input.script().to_data(false);
        std::string message(script.begin() + sizeof(uint64_t), script.end());
        std::cout << message << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lbitcoin",
                    "-L#{boost.opt_lib}", "-lboost_system",
                    "-o", "test"
    system "./test"
  end
end
