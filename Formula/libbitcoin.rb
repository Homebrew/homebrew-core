class Libbitcoin < Formula
  desc "Bitcoin Cross-Platform C++ Development Toolkit"
  homepage "https://github.com/libbitcoin/libbitcoin-system"
  url "https://github.com/libbitcoin/libbitcoin-system/archive/v3.6.0.tar.gz"
  sha256 "5bcc4c31b53acbc9c0d151ace95d684909db4bf946f8d724f76c711934c6775c"
  license "AGPL-3.0"
  revision 8

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0833776d4e928b8a5bc65df18153d3f8162eaf3ab15b58e0dba8ab6f138319d8"
    sha256 cellar: :any,                 arm64_monterey: "0060cc24d1816bfa7e5bf5c86ecc627588de61bc9f1295e684e96bee6226e60b"
    sha256 cellar: :any,                 arm64_big_sur:  "548ad7d450169e5769ac187c406264e68aaf94564f135de119a79ad00f6621dd"
    sha256 cellar: :any,                 ventura:        "2b14ced640cb54167f0732b94881d2ec55d5cf3cb8992865daf3988125c9aae3"
    sha256 cellar: :any,                 monterey:       "c007205d17c148faa8770c22e0147b204aa7f29042801f42c10a9314fc10b5c6"
    sha256 cellar: :any,                 big_sur:        "bbd766cb1ee0caffc03f6a38d5d838de9aa7db45c7cdfa4773211c37cec73595"
    sha256 cellar: :any,                 catalina:       "701cfe443d10ff56bb8765ad0ede7658aba928e3a996213c94f26303069f9fc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa6d0e3356cb07b7efb3a6de11b013cc4358a134d20cd0006ee35c853045b241"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  # https://github.com/libbitcoin/libbitcoin-system/issues/1234
  depends_on "boost@1.76"
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
                          "--with-boost-libdir=#{Formula["boost@1.76"].opt_lib}",
                          "--with-png",
                          "--with-qrencode"
    system "make", "install"
  end

  test do
    boost = Formula["boost@1.76"]
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
    system ENV.cxx, "-std=c++11", "test.cpp",
                    "-I#{boost.include}",
                    "-L#{lib}", "-lbitcoin",
                    "-L#{boost.lib}", "-lboost_system",
                    "-o", "test"
    system "./test"
  end
end
