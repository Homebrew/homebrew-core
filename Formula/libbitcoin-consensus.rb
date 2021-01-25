class LibbitcoinConsensus < Formula
  desc "Bitcoin Consensus Library (optional)"
  homepage "https://github.com/libbitcoin/libbitcoin-consensus"
  url "https://github.com/libbitcoin/libbitcoin-consensus/archive/v3.6.0.tar.gz"
  sha256 "a4252f40910fcb61da14cf8028bf3824125bacb0fc251491c9bb4e2818065fca"
  license "AGPL-3.0"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "57d876817c6af49a0f396fd62e42ff8ded2631b9ff73ad1651418be092e758fa" => :big_sur
    sha256 "2295fa9610ecc2ea704ecf362ccfdf356491a633b161931b96ef0bc64ed9e77b" => :arm64_big_sur
    sha256 "4cc94dd5243acf68c4b7e0a2a8071a407fc00ff7ad2f8c2b3ff688d07cd1b362" => :catalina
    sha256 "72719cd5ad88afff167530b1b55df7ce28e7920bf0daab69758e87d00804006a" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

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
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp",
                    "-I#{libexec}/include",
                    "-L#{lib}", "-L#{libexec}/lib",
                    "-lbitcoin-consensus",
                    "-o", "test"
    system "./test"
  end
end
