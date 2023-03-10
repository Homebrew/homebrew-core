class CppHttplib < Formula
  desc "C++ header-only HTTP/HTTPS server and client library"
  homepage "https://github.com/yhirose/cpp-httplib"
  url "https://github.com/yhirose/cpp-httplib/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "0e56c25c63e730ebd42e2beda6e7cb1b950131d8fc00d3158b1443a8d76f41ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "679c1124b1f3aa7e720eb719f14090dc98823324337d621c07d86a2c19383d92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef3b3985b87eaeebec92aa67cb1c583d1504b726a592e929f0094f637eb7db27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6940f06d002b3c5eb548d6f04850851f47b2e84fb57db6d1aad4db78234de4f3"
    sha256 cellar: :any_skip_relocation, ventura:        "d9d47835da8f4e30c959b29ab2fe44d79ed8837b745c5134152940b1daef2d47"
    sha256 cellar: :any_skip_relocation, monterey:       "d7e16d1b3dcccd735176b5b4796f2c8580fd58fa51dce4d8ba6c82360204a597"
    sha256 cellar: :any_skip_relocation, big_sur:        "87249cb78d974d368e93bb7e258932c414cea9c27ad28934591c665b2e67198d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7710d58a0bcade248027d547b943ff09f7b4d602758206cbd9ef5d14269cfd30"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "build", *std_meson_args
    system "meson", "compile", "-C", "build"
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
