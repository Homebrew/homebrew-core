class Libbitcoin < Formula
  desc "Bitcoin Cross-Platform C++ Development Toolkit"
  homepage "https://libbitcoin.org/"
  url "https://github.com/libbitcoin/libbitcoin/archive/v3.3.0.tar.gz"
  sha256 "391913a73615afcb42c6a7c4736f23888cfc999a899fc38395ddcbd560251d94"
  revision 1

  bottle do
    cellar :any
    sha256 "7ce5a70a7fe2e5b2db4b66fbda711d38d3f3cf55c4c835ff9710168aa609e641" => :sierra
    sha256 "4405d82c91471dd138879c08d06fc486b5bf9c3e27aff1d094349e795e4270f7" => :el_capitan
    sha256 "f7bf5121903b955d5d79da1626d491504d79a1c2302d9e1b42ef5f40fc9c07e5" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"

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
                            "--enable-module-recovery"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", "#{libexec}/lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}",
                    "-lbitcoin", "-lboost_system", "-o", "test"
    system "./test"
  end
end
