class Libbitcoin < Formula
  desc "Bitcoin Cross-Platform C++ Development Toolkit"
  homepage "https://github.com/libbitcoin/libbitcoin-system"
  url "https://github.com/libbitcoin/libbitcoin-system/archive/v3.8.0.tar.gz"
  sha256 "b5dd2a97289370fbb93672dd3114383f30d877061de1d1683fa8bdda5309bfa2"
  license "AGPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_ventura:  "f0a93d33bc38415aaa6d6da0d135b151f43e8e9132ab1d2aa934c8112dcd950f"
    sha256                               arm64_monterey: "3f308c8e5a160fc45a51e0affebe5dcb2382f28bbf00eaf98152374b57ed19dd"
    sha256                               arm64_big_sur:  "e03b859c607df3b9b21a813645721a4d11b1d7923e3770ed5532551c5fe1aea9"
    sha256                               ventura:        "389ed798a948326062f7315a8648233b62164e7d26a39e8895296bc78dff7c26"
    sha256                               monterey:       "bea6b3ee59b7f3c4b866971d50eacfb794701331831e42235af7ecb61a27d086"
    sha256                               big_sur:        "dde076ed507c4b564802ff9a60e896aca09fdd7ca6727b7ab105555f5ecbd7bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81ab5be0a7b329e9eff96942a69ecbbdcc4062254d8c83b6a003935cffd01659"
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
    url "https://github.com/libbitcoin/secp256k1/archive/v0.1.0.20.tar.gz"
    sha256 "61583939f1f25b92e6401e5b819e399da02562de663873df3056993b40148701"
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
      #include <bitcoin/system.hpp>
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
                    "-L#{lib}", "-lbitcoin-system",
                    "-L#{boost.lib}", "-lboost_system",
                    "-o", "test"
    system "./test"
  end
end
