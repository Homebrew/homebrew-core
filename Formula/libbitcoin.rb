class Libbitcoin < Formula
  desc "Bitcoin Cross-Platform C++ Development Toolkit"
  homepage "https://libbitcoin.org/"
  url "https://github.com/libbitcoin/libbitcoin-system/archive/v3.5.0.tar.gz"
  sha256 "44ecd8b0de0dff2296f03e9c7f42a0afb9ac4f916aeaf6de2bffd0ccc05790b5"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "c067b304ad7e0c7044b6d7d7cf007cad236f48e0fafa1c56a62f8cf8c4d27b33" => :mojave
    sha256 "1a6ac051450d8008f8a9fc233ab34ab2be3e8f7dad36037b82fb004e9636d335" => :high_sierra
    sha256 "b3fa4e3085d1b38333cd9df107d9765cbbd1651f6f247ef95c55d31c88dcf7f2" => :sierra
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
