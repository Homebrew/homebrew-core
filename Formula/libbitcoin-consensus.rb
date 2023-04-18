class LibbitcoinConsensus < Formula
  desc "Bitcoin Consensus Library (optional)"
  homepage "https://github.com/libbitcoin/libbitcoin-consensus"
  url "https://github.com/libbitcoin/libbitcoin-consensus/archive/v3.6.0.tar.gz"
  sha256 "a4252f40910fcb61da14cf8028bf3824125bacb0fc251491c9bb4e2818065fca"
  license "AGPL-3.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "46734a045992d1a1e2cba4689ab58537f5e7729310d6acb476178d170c54d63d"
    sha256 cellar: :any,                 arm64_monterey: "1a6488ba887d026f465280fc3f2c27847d539eca7c3ab733eff3e4bed89d6c26"
    sha256 cellar: :any,                 arm64_big_sur:  "b2a70f871df4a376246e9882383751a65d04e7f30ff1b0c7abab507cf3d80e49"
    sha256 cellar: :any,                 ventura:        "c1fa7160b3b53e24caf0b92cc8cd1276f859966a15aac8e2950b67bf2e301ac3"
    sha256 cellar: :any,                 monterey:       "357a443d52c298a45747b15297806704f3bcf81c43f0ccf7066f9e4653356e5a"
    sha256 cellar: :any,                 big_sur:        "31b62a85a41d440a6f2772c348288c89b8ff0de5c6eaaf911b4891a3796c6c60"
    sha256 cellar: :any,                 catalina:       "c45b5944cedcd5ad9733ea30e49a644851264abf40f8d38cbc8b67ddf33ce21c"
    sha256 cellar: :any,                 mojave:         "b6d7bed977f2e337a0fd2da7f56035323ba8c1d59503ccdb3fef5f6033cf7eef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ccf6f4e46745f168dbf5c77f36d30041138b8c0a9a7c3de27060fd5627b7270"
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
