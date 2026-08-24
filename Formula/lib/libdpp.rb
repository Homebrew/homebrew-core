class Libdpp < Formula
  desc "C++ Discord API Bot Library"
  homepage "https://dpp.dev/"
  url "https://github.com/brainboxdotcc/DPP/archive/refs/tags/v10.1.6.tar.gz"
  sha256 "65cf9e5fbc7b40e3fadaf742fa87da9cdede46651e35007c7b45cb765bfc17ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b6a0ebb56a7a7276c70fe9294f077a123cb4e2a2a28290a399b009e14e4faaef"
    sha256 cellar: :any, arm64_sequoia: "702ad39019c981065b091db3558cb7c47edf886343d1a48eece0b51fcb253f5e"
    sha256 cellar: :any, arm64_sonoma:  "3ae7f67d8b918d3a6f2cbc13547bf867a4d20e926a7dbcb08df4ea6098c08822"
    sha256 cellar: :any, sonoma:        "c843cd7aa4bcc045bbf373bd50911ed673cb087c932606542169a8706d0c2d72"
    sha256 cellar: :any, arm64_linux:   "57ab5940f7370efd01b8d7215ddc995ed586ba938a102fd1ea0b8142a4a2afcc"
    sha256 cellar: :any, x86_64_linux:  "87925835649a9a7e3001ea32b9c25d84da0b4f537d045b3fab2bbf247fa37663"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "openssl@4"
  depends_on "opus"
  depends_on "pkgconf"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DDPP_BUILD_TEST=OFF",
                    "-DDPP_NO_CONAN=ON",
                    "-DDPP_NO_VCPKG=ON",
                    "-DDPP_USE_EXTERNAL_JSON=ON",
                    "-DRUN_LDCONFIG=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <dpp/dpp.h>
      #include <unistd.h> // for alarm

      void timeout_handler(int signum) {
          std::cerr << "Connection error: timed out" << std::endl;
          exit(1);
      }

      int main() {
          std::signal(SIGALRM, timeout_handler);
          alarm(2);

          dpp::cluster bot("invalid_token");

          bot.on_log(dpp::utility::cout_logger());

          try {
              bot.start(dpp::st_wait);
          }
          catch (const dpp::connection_exception &e) {
              std::cout << "Connection error: " << e.what() << std::endl;
              return 1;
          }
          catch (const dpp::invalid_token_exception &e) {
              std::cout << "Invalid token." << std::endl;
              return 1;
          }
          return 0;
      }
    CPP
    system ENV.cxx, "-std=c++20", "-L#{lib}", "-I#{include}", "test.cpp", "-o", "test", "-ldpp"
    assert_match "Connection error", shell_output("./test 2>&1", 1)
  end
end
