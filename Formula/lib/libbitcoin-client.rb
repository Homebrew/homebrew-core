class LibbitcoinClient < Formula
  desc "Bitcoin Client Query Library"
  homepage "https://github.com/libbitcoin/libbitcoin-client"
  url "https://github.com/libbitcoin/libbitcoin-client/archive/v3.8.0.tar.gz"
  sha256 "cfd9685becf620eec502ad53774025105dda7947811454e0c9fea30b27833840"
  license "AGPL-3.0"
  revision 1

  bottle do
    sha256                               arm64_ventura:  "6cd52d67b61c293fe9eae7a05007f0d2798c7bdf1483a9145adf48a7daabdb64"
    sha256                               arm64_monterey: "da7ac2398a151e1b0af03207e4eef26d08df8b565ecbaddad84b3b43ac9a7e37"
    sha256                               arm64_big_sur:  "768a1626433335c8bb487df321106d3013bab53806f7e8ca029c46db0b61bd4a"
    sha256                               ventura:        "3b0f4378906286d1d77c73b7d004ad862fa05df23d3452e2de008f1f0cb0f0b8"
    sha256                               monterey:       "c4557d75674e0ad4f90b43819ea84790f5d0dccca2540948b6c9aaf8a9ef3d3d"
    sha256                               big_sur:        "1a1bfda7ce37123ab469c8d946d005afbda55b371a349479ec516cc2076fefd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b51731e5dccac31a9616b2d0e7cc87d0a33277d15f3043c41fda35986f63e26"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  # https://github.com/libbitcoin/libbitcoin-system/issues/1234
  depends_on "boost@1.76"
  depends_on "libbitcoin-protocol"

  def install
    ENV.cxx11
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost-libdir=#{Formula["boost@1.76"].opt_lib}"
    system "make", "install"
  end

  test do
    boost = Formula["boost@1.76"]
    (testpath/"test.cpp").write <<~EOS
      #include <bitcoin/client.hpp>
      class stream_fixture
        : public libbitcoin::client::stream
      {
      public:
        libbitcoin::data_stack out;

        virtual int32_t refresh() override
        {
          return 0;
        }

        virtual bool read(stream& stream) override
        {
          return false;
        }

        virtual bool write(const libbitcoin::data_stack& data) override
        {
          out = data;
          return true;
        }
      };
      static std::string to_string(libbitcoin::data_slice data)
      {
        return std::string(data.begin(), data.end()) + "\0";
      }
      static void remove_optional_delimiter(libbitcoin::data_stack& stack)
      {
        if (!stack.empty() && stack.front().empty())
          stack.erase(stack.begin());
      }
      static const uint32_t test_height = 0x12345678;
      static const char address_satoshi[] = "1PeChFbhxDD9NLbU21DfD55aQBC4ZTR3tE";
      #define PROXY_TEST_SETUP \
        static const uint32_t retries = 0; \
        static const uint32_t timeout_ms = 2000; \
        static const auto on_error = [](const libbitcoin::code&) {}; \
        static const auto on_unknown = [](const std::string&) {}; \
        stream_fixture capture; \
        libbitcoin::client::proxy proxy(capture, on_unknown, timeout_ms, retries)
      #define HANDLE_ROUTING_FRAMES(stack) \
        remove_optional_delimiter(stack);
      int main() {
        PROXY_TEST_SETUP;

        const auto on_reply = [](const libbitcoin::chain::history::list&) {};
        proxy.blockchain_fetch_history3(on_error, on_reply, libbitcoin::wallet::payment_address(address_satoshi), test_height);

        HANDLE_ROUTING_FRAMES(capture.out);
        assert(capture.out.size() == 3u);
        assert(to_string(capture.out[0]) == "blockchain.fetch_history3");
        assert(libbitcoin::encode_base16(capture.out[2]) == "f85beb6356d0813ddb0dbb14230a249fe931a13578563412");
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-I#{boost.include}",
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin-system",
                    "-L#{lib}", "-lbitcoin-client",
                    "-L#{boost.lib}", "-lboost_system"
    system "./test"
  end
end
