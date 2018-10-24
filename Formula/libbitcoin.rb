class Libbitcoin < Formula
  desc "Bitcoin Cross-Platform C++ Development Toolkit"
  homepage "https://libbitcoin.org/"
  url "https://github.com/libbitcoin/libbitcoin/archive/v3.5.0.tar.gz"
  sha256 "214d9cd6581330b0e1f6fd8f0c634c46b75ae5515806ecac189f21c0291ae2d9"
  revision 2

  bottle do
    cellar :any
    sha256 "17ea27f4b1427f7ba621b7a821d7749dc522b3a8b6819973073a3762680edb90" => :mojave
    sha256 "45fc36aa8d143455d4aeca84faea198711256bafc33429aaef9ebae9babbe3d5" => :high_sierra
    sha256 "525d2589227cb234853720d5d47b8b6d454849bb0398663bcfdf735115602e39" => :sierra
    sha256 "5c14adb5b6f2abc5b02e4126cd86087ea78ef040829f721a55633f49c9350c9f" => :el_capitan
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
