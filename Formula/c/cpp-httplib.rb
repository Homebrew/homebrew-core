class CppHttplib < Formula
  desc "C++ header-only HTTP/HTTPS server and client library"
  homepage "https://github.com/yhirose/cpp-httplib"
  url "https://github.com/yhirose/cpp-httplib/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "2a4503f9f2015f6878baef54cd94b01849cc3ed19dfe95f2c9775655bea8b73f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b0549277f78b65756524095ef00e0761b034cda719d79b930cebb8799c9cf5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b0549277f78b65756524095ef00e0761b034cda719d79b930cebb8799c9cf5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b0549277f78b65756524095ef00e0761b034cda719d79b930cebb8799c9cf5f"
    sha256 cellar: :any_skip_relocation, ventura:        "0b0549277f78b65756524095ef00e0761b034cda719d79b930cebb8799c9cf5f"
    sha256 cellar: :any_skip_relocation, monterey:       "0b0549277f78b65756524095ef00e0761b034cda719d79b930cebb8799c9cf5f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b0549277f78b65756524095ef00e0761b034cda719d79b930cebb8799c9cf5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d88743dcd307b714a0aaa119879a49b2d1a7ec5d92b97fed3dbb1db1ccb46024"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  fails_with :clang do
    build 1300
    cause <<~EOS
      include/httplib.h:5278:19: error: no viable overloaded '='
      request.matches = {};
      ~~~~~~~~~~~~~~~ ^ ~~
    EOS
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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

    fork do
      exec "./server"
    end
    sleep 3
    assert_match "Hello World!", shell_output("./client")
  end
end
