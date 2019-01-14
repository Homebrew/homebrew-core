class Libbitcoin < Formula
  desc "Bitcoin Cross-Platform C++ Development Toolkit"
  homepage "https://libbitcoin.org/"
  url "https://github.com/libbitcoin/libbitcoin/archive/v3.5.0.tar.gz"
  sha256 "214d9cd6581330b0e1f6fd8f0c634c46b75ae5515806ecac189f21c0291ae2d9"
  revision 2

  bottle do
    cellar :any
    sha256 "4cd1d0fb5b989561a99bfea5d54d164a0b5f9131fdbcff021c40ebf8e484bb32" => :mojave
    sha256 "7fd9794276924b9e42d36df244fe6071452fa06d9a726e348e6f121a9efc3abd" => :high_sierra
    sha256 "06780e45001a9c99e90afd9e571216d22f42730c07516f63dda6debded110568" => :sierra
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
                          "--with-png",
                          "--with-qrencode"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <bitcoin/bitcoin.hpp>
      int main() {
        const auto block = bc::chain::block::genesis_mainnet();
        const auto& tx = block.transactions().front();
        const auto& input = tx.inputs().front();
        const auto script = input.script().to_data(false);
        std::string message(script.begin() + sizeof(uint64_t), script.end());
        bc::cout << message << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lbitcoin",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_system",
                    "-o", "test"
    system "./test"
  end
end
