class Libbitcoin < Formula
  desc "Bitcoin Cross-Platform C++ Development Toolkit"
  homepage "https://github.com/libbitcoin/libbitcoin-system"
  url "https://github.com/libbitcoin/libbitcoin-system/archive/v3.6.0.tar.gz"
  sha256 "5bcc4c31b53acbc9c0d151ace95d684909db4bf946f8d724f76c711934c6775c"
  license "AGPL-3.0"
  revision 6

  bottle do
    cellar :any
    sha256 "e082921a7292db532b49c3fe2ff70df87c90f7ac2e9b5e51fe3b4bb0c7461c19" => :big_sur
    sha256 "98865b9471e441a3d3ee30c38c568b546bf338700953ab9a784daed2775ea7d7" => :catalina
    sha256 "d0a5c4652789897e610767855d1bb27923df8735084f1dd7820a0e6c435737c7" => :mojave
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
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
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
        std::cout << message << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lbitcoin",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_system",
                    "-o", "test"
    system "./test"
  end
end
