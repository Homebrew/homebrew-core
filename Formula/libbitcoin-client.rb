class LibbitcoinClient < Formula
  desc "Bitcoin Client Query Library"
  homepage "https://github.com/libbitcoin/libbitcoin-client"
  url "https://github.com/libbitcoin/libbitcoin-client/archive/v3.6.0.tar.gz"
  sha256 "75969ac0a358458491b101cae784de90452883b5684199d3e3df619707802420"
  license "AGPL-3.0"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "54e596753c425921e98f9237f5f9b0eea6771edf2c785a79650b840fee30d770"
    sha256 cellar: :any,                 arm64_big_sur:  "1436d1f380bb51199a8b92053c9822e314c0febac9bc8757bf0f4c51fbcc7798"
    sha256 cellar: :any,                 monterey:       "46e417e5a41ee798bf9834494a9a0b4499b144c7c3104aad32a4c51e6bb07458"
    sha256 cellar: :any,                 big_sur:        "8c0a09aefcaf36a2b9831884c7ce698d2ad533f3aca8b4d30a4f63611022535a"
    sha256 cellar: :any,                 catalina:       "d44ec063ad2da0e31a12d9f59c65962b03e60c1fedfbe002b62dbae6cedc727a"
    sha256 cellar: :any,                 mojave:         "fed0d06847db159818373b9c8845f185dc58dbeaa761f0f8a8bc6267f3b4030a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2f962444775e331d8e13c937a16ea977b1080c32a2c10750bd304de03e4719e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin-protocol"

  def install
    ENV.cxx11
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}"
    system "make", "install"
  end

  test do
    boost = Formula["boost"]
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
                    "-L#{Formula["libbitcoin"].opt_lib}", "-lbitcoin",
                    "-L#{lib}", "-lbitcoin-client",
                    "-L#{boost.opt_lib}", "-lboost_system"
    system "./test"
  end
end
