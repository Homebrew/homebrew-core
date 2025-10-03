class Pistache < Formula
  desc "Modern, fast, elegant HTTP + REST C++17 framework with pleasant API"
  homepage "https://github.com/pistacheio/pistache"
  url "https://github.com/pistacheio/pistache/archive/refs/tags/v0.4.26.tar.gz"
  sha256 "29af6562547497acf6f49170661786fe8cf1ed3712ad80e69c53da4661c59544"
  license "Apache-2.0"
  head "https://github.com/pistacheio/pistache.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e3debddab926a1b7ddc20bec37d36630bb517f44fb96d98d37c503db10d5fe82"
    sha256 cellar: :any, arm64_sequoia: "df6e5955a69ba59d16fa1085e2a264b6886ac13eaefcfdad36b6cde24fdd357f"
    sha256 cellar: :any, arm64_sonoma:  "17198b6e042abadfa94de4824bb3e9d9a2696230ed2d54cae8dabf8550467fd7"
    sha256 cellar: :any, arm64_ventura: "d7a4d961bd52ea6e84601692baf0aa290738c73f31b2522627e766e386fe470f"
    sha256 cellar: :any, sonoma:        "8eaf723d1a39743fee0bbcd114aba4bb58cc28a1a5dd2b6ee6a398c1e6164e98"
    sha256 cellar: :any, ventura:       "c15f1071afc06d9f6f60e54921af214d6c8e6787db6e9ca0fc249c9d208b5aef"
    sha256               arm64_linux:   "f2f94bda2565558e53b6ce5359d82dddf46c486f19744622795da71f2dcb28dc"
    sha256               x86_64_linux:  "e864df73e63ce4399b8c6324f3b86e36c83128f0034aceea2b6dd3941f8a5385"
  end

  depends_on "cmake" => :build # for howard-hinnant-date
  depends_on "cpp-httplib" => :build
  depends_on "googletest" => :build
  depends_on "howard-hinnant-date" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rapidjson" => :build

  depends_on "brotli"
  depends_on "libevent"
  depends_on "openssl@3"
  depends_on "zstd"

  uses_from_macos "curl" => :build
  uses_from_macos "zlib"

  def install
    system "meson", "setup", "build",
                    "-DPISTACHE_USE_SSL=true",
                    "-DPISTACHE_BUILD_EXAMPLES=false",
                    "-DPISTACHE_BUILD_TESTS=false",
                    "-DPISTACHE_BUILD_DOCS=false",
                    "-DPISTACHE_USE_CONTENT_ENCODING_DEFLATE=true",
                    "-DPISTACHE_USE_CONTENT_ENCODING_BROTLI=true",
                    "-DPISTACHE_USE_CONTENT_ENCODING_ZSTD=true",
                    *std_meson_args

    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      // Testing multiple clients making requests of a multithreaded server

      #include <pistache/async.h>
      #include <pistache/client.h>
      #include <pistache/endpoint.h>
      #include <pistache/http.h>

      #include <chrono>
      #include <string>
      #include <future>

      using namespace Pistache;
      using namespace std::chrono;

      struct HelloHandler : public Http::Handler
      {
          HTTP_PROTOTYPE(HelloHandler)

          void onRequest(const Http::Request& /*request*/,
                         Http::ResponseWriter writer) override
          {
              writer.send(Http::Code::Ok, "Hello, World!");
          }
      };

      static int clientLogicFunc(size_t response_size,
                                 const std::string& server_page,
                                 int wait_seconds)
      {
          Http::Experimental::Client client;
          client.init();

          std::vector<Async::Promise<Http::Response>> responses;
          auto rb = client.get(server_page);

          int resolver_counter = 0;
          int reject_counter   = 0;
          for (size_t i = 0; i < response_size; ++i)
          {
              auto response = rb.send();

              response.then(
                  [&resolver_counter, pos = i](Http::Response resp) {
                      if (resp.code() == Http::Code::Ok)
                      {
                          ++resolver_counter;
                      }
                  },
                  [&reject_counter, pos = i](std::exception_ptr exc) {
                      std::cout << "Request rejected" << std::endl;
                      PrintException excPrinter;

                      excPrinter(exc);
                      ++reject_counter;
                  });
              responses.push_back(std::move(response));
          }

          { // encapsulate
              auto sync = Async::whenAll(responses.begin(), responses.end());
              Async::Barrier<std::vector<Http::Response>> barrier(sync);
              barrier.wait_for(std::chrono::seconds(wait_seconds));
          }

          client.shutdown();
          return resolver_counter;
      }

      int main()
      {
          const Pistache::Address address("localhost", Pistache::Port(0));

          Http::Endpoint server(address);
          auto flags       = Tcp::Options::ReuseAddr;
          auto server_opts = Http::Endpoint::options().flags(flags).threads(3);
          server.init(server_opts);
          server.setHandler(Http::make_handler<HelloHandler>());
          server.serveThreaded();

          const std::string server_address =
              "localhost:" + server.getPort().toString();

          const int SIX_SECONDS_TIMOUT        = 6;
          const int FIRST_CLIENT_REQUEST_SIZE = 4;
          std::future<int> result1(std::async(clientLogicFunc,
                                   FIRST_CLIENT_REQUEST_SIZE, server_address,
                                   SIX_SECONDS_TIMOUT));
          const int SECOND_CLIENT_REQUEST_SIZE = 5;
          std::future<int> result2(
              std::async(clientLogicFunc, SECOND_CLIENT_REQUEST_SIZE,
                         server_address, SIX_SECONDS_TIMOUT));

          int res1 = result1.get();
          int res2 = result2.get();

          server.shutdown();

          if (res1 != FIRST_CLIENT_REQUEST_SIZE)
          {
              std::cerr << "Response count res1 is " << res1 << ", expected "
                        << FIRST_CLIENT_REQUEST_SIZE << std::endl;
              return 1;
          }

          if (res2 != SECOND_CLIENT_REQUEST_SIZE)
          {
              std::cerr << "Response count res2 is " << res2 << ", expected "
                        << SECOND_CLIENT_REQUEST_SIZE << std::endl;
              return 2;
          }

        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lpistache", "-o", "test"
    system "./test"
  end
end
