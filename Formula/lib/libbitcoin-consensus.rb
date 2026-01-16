class LibbitcoinConsensus < Formula
  desc "Bitcoin Consensus Library (optional)"
  homepage "https://github.com/libbitcoin/libbitcoin-consensus"
  url "https://github.com/libbitcoin/libbitcoin-consensus/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "3f63b233a25323ff81de71a6c96455a6f5141e21cb0678a2304b36b56e771ca2"
  license "AGPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "a208eab2c355028b035129dac7a3f1316dff9cec8d84aeee74a0ffc66fc94ac4"
    sha256 cellar: :any,                 arm64_sequoia:  "0becb75eb0a0540a4cb6554887c3b345777278ec8ed8e5fafd76057722c755c6"
    sha256 cellar: :any,                 arm64_sonoma:   "12ab6ca60756919e7347031905778cf42151bc6d5294cf9826a7341a69c6b3dc"
    sha256 cellar: :any,                 arm64_ventura:  "495b1ee3bc1d01755b48ced48c019b2bf40f1361c529a1186c66449801f25708"
    sha256 cellar: :any,                 arm64_monterey: "82cdc41015f185c56a5c317ec125d1f6d74e298611afd8e0efb05135668c9a47"
    sha256 cellar: :any,                 arm64_big_sur:  "dbb11bd9f43f28ff31be7248a0c443d7359c7ceeb01227c1c099ea613d869f35"
    sha256 cellar: :any,                 sonoma:         "6f7adeb8f31361a7962ec8130c23829f8a8c5efe265d54c541bce38642a9fbb4"
    sha256 cellar: :any,                 ventura:        "2f8f5925ff397fd8b1f6f1c499e3828c25830b551e678bbb24898912825fc328"
    sha256 cellar: :any,                 monterey:       "3b0a76702e478bae5a2b864b2bfaf4cbc2f658582454fa4ab0ccf534d4c9fae5"
    sha256 cellar: :any,                 big_sur:        "1ef57e9412ff7a67edd7e7557b8848f321f1355c0841dfb0cf6167a0d2e37447"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9f14d11d115821d69e9aff1270ad08ef647468621148af9693b71d8d59fa0a57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32b0d72b5ff1f2de8effc219182d08b8e3a4a92ec714ddea76691196ca42df61"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  resource "secp256k1" do
    url "https://github.com/libbitcoin/secp256k1/archive/refs/tags/v0.1.0.20.tar.gz"
    sha256 "61583939f1f25b92e6401e5b819e399da02562de663873df3056993b40148701"
  end

  def install
    ENV.cxx11
    resource("secp256k1").stage do
      system "./autogen.sh"
      system "./configure", "--disable-silent-rules",
                            "--enable-module-recovery",
                            "--with-bignum=no",
                            *std_configure_args(prefix: libexec)
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", "#{libexec}/lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <string>
      #include <vector>
      #include <assert.h>
      #include <bitcoin/consensus.hpp>
      typedef std::vector<uint8_t> data_chunk;
      static unsigned from_hex(const char ch)
      {
        if ('A' <= ch && ch <= 'F')
          return 10 + ch - 'A';
        if ('a' <= ch && ch <= 'f')
          return 10 + ch - 'a';
        return ch - '0';
      }
      static bool decode_base16_private(uint8_t* out, size_t size, const char* in)
      {
        for (size_t i = 0; i < size; ++i)
        {
          if (!isxdigit(in[0]) || !isxdigit(in[1]))
            return false;
          out[i] = (from_hex(in[0]) << 4) + from_hex(in[1]);
            in += 2;
        }
        return true;
      }
      static bool decode_base16(data_chunk& out, const std::string& in)
      {
        // This prevents a last odd character from being ignored:
        if (in.size() % 2 != 0)
          return false;
        data_chunk result(in.size() / 2);
        if (!decode_base16_private(result.data(), result.size(), in.data()))
          return false;
        out = result;
        return true;
      }
      static libbitcoin::consensus::verify_result test_verify(const std::string& transaction,
        const std::string& prevout_script, uint64_t prevout_value=0,
        uint32_t tx_input_index=0, const uint32_t flags=libbitcoin::consensus::verify_flags_p2sh,
        int32_t tx_size_hack=0)
      {
        data_chunk tx_data, prevout_script_data;
        assert(decode_base16(tx_data, transaction));
        assert(decode_base16(prevout_script_data, prevout_script));
        return libbitcoin::consensus::verify_script(&tx_data[0], tx_data.size() + tx_size_hack,
          &prevout_script_data[0], prevout_script_data.size(), prevout_value,
          tx_input_index, flags);
      }
      int main() {
        const libbitcoin::consensus::verify_result result = test_verify("42", "42");
        assert(result == libbitcoin::consensus::verify_result_tx_invalid);
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp",
                    "-I#{libexec}/include",
                    "-L#{lib}", "-L#{libexec}/lib",
                    "-lbitcoin-consensus",
                    "-o", "test"
    system "./test"
  end
end
