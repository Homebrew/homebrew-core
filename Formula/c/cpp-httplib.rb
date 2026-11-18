class CppHttplib < Formula
  desc "C++ header-only HTTP/HTTPS server and client library"
  homepage "https://yhirose.github.io/cpp-httplib/"
  url "https://github.com/yhirose/cpp-httplib/archive/refs/tags/v0.67.0.tar.gz"
  sha256 "be711ddaf7a3655d8f23aa5655709250b24d247aedd4b2629989d18b6164e5be"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8a9372a5885141f6d22b6aa6b2664f3458c58c6c79bfc5be89017389c6abd08c"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4" => :build

  on_linux do
    depends_on "zlib-ng-compat" => :build
  end

  fails_with :clang do
    build 1300
    cause <<~EOS
      include/httplib.h:5278:19: error: no viable overloaded '='
      request.matches = {};
      ~~~~~~~~~~~~~~~ ^ ~~
    EOS
  end

  allow_network_access! :test

  def install
    # Set args for consistent dependencies used in generated CMake config
    args = %w[
      -DHTTPLIB_REQUIRE_OPENSSL=ON
      -DHTTPLIB_REQUIRE_ZLIB=ON
      -DHTTPLIB_USE_BROTLI_IF_AVAILABLE=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"server.cpp").write <<~CPP
      #include <httplib.h>
      using namespace httplib;

      int main(void) {
        Server svr;

        svr.Get("/hi", [](const Request &, Response &res) {
          res.set_content("Hello World!", "text/plain");
        });

        svr.listen("0.0.0.0", 8080);
      }
    CPP
    (testpath/"client.cpp").write <<~CPP
      #include <httplib.h>
      #include <iostream>
      using namespace httplib;
      using namespace std;

      int main(void) {
        Client cli("localhost", 8080);
        if (auto res = cli.Get("/hi")) {
          cout << res->status << endl;
          cout << res->get_header_value("Content-Type") << endl;
          cout << res->body << endl;
          return 0;
        } else {
          return 1;
        }
      }
    CPP
    system ENV.cxx, "server.cpp", "-I#{include}", "-lpthread", "-std=c++11", "-o", "server"
    system ENV.cxx, "client.cpp", "-I#{include}", "-lpthread", "-std=c++11", "-o", "client"

    spawn "./server"
    sleep 3
    assert_match "Hello World!", shell_output("./client")
  end
end
