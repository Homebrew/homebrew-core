class LibbitcoinClient < Formula
  desc "Bitcoin Client Query Library"
  homepage "https://github.com/libbitcoin/libbitcoin-client"
  url "https://github.com/libbitcoin/libbitcoin-client/archive/v3.6.0.tar.gz"
  sha256 "75969ac0a358458491b101cae784de90452883b5684199d3e3df619707802420"
  license "AGPL-3.0"
  revision 8

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b89e10498e220be618efdacc2e33d15d8d5cfe54b7b1986fde9e16c180c92c02"
    sha256 cellar: :any,                 arm64_monterey: "c39d34c74a9162ff8fe454100407ff6aefe8dedcdfd144df5435ed321d1a243b"
    sha256 cellar: :any,                 arm64_big_sur:  "9940b9110b8ff68a6be7c67dbeabe7c7f8d42114185990d637753ec799ac2a92"
    sha256 cellar: :any,                 ventura:        "4d5874a7e85e5bfbd3dcb988aa0549f9e80ab0ecea08388d3d1b8a9b0cf45246"
    sha256 cellar: :any,                 monterey:       "da7f7247c47202c3fa6d43ab62a815a1514b8453040776844df05688462ce583"
    sha256 cellar: :any,                 big_sur:        "9b9131622c37929c721083d3ae02d5db5b74d47730617ecdff0e5345bd326b56"
    sha256 cellar: :any,                 catalina:       "d0198baac9163a586987faf548f8f27f1918291a3454ed2e397a7c6040b87170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddf5a6b6f46abdca1942682e3863fc1ae75f53195f60419089b15cedb1e90d15"
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
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin",
                    "-L#{lib}", "-lbitcoin-client",
                    "-L#{boost.lib}", "-lboost_system"
    system "./test"
  end
end
