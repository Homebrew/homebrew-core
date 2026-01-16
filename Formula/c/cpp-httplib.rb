class CppHttplib < Formula
  desc "C++ header-only HTTP/HTTPS server and client library"
  homepage "https://github.com/yhirose/cpp-httplib"
  url "https://github.com/yhirose/cpp-httplib/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "2818b183757e29dd52b47a185f0cea9ef2d0fba377d8710b450a26328e51c2fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5863080e0eb81f1e9e15c1ddf6237d05ee136e20a2be6fd0b76c075618c665f7"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3" => :build
  uses_from_macos "zlib" => :build

  fails_with :clang do
    build 1300
    cause <<~EOS
      include/httplib.h:5278:19: error: no viable overloaded '='
      request.matches = {};
      ~~~~~~~~~~~~~~~ ^ ~~
    EOS
  end

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
