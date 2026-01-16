class Libdpp < Formula
  desc "C++ Discord API Bot Library"
  homepage "https://github.com/brainboxdotcc/DPP"
  url "https://github.com/brainboxdotcc/DPP/archive/refs/tags/v10.1.4.tar.gz"
  sha256 "f11b6d3fc5cc8febcf672b573ca74293ead6c6ea48a66ac0316ab9a5cbd09441"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "23357f73249aee45e72d7930d5b6588572cc247ac02631e1c42519c418dcd24b"
    sha256 cellar: :any,                 arm64_sequoia: "8884ff98ec895cc234dec97e4f407be83ce1707746cd3e0fd179e7bfb9ba3693"
    sha256 cellar: :any,                 arm64_sonoma:  "b5348aa38172f3f7504685b2ce4d984878725a6d659a961b9b7de886c89a571e"
    sha256 cellar: :any,                 sonoma:        "184fde831dcf36522ed400cc3d34eb85d8ff8f239cb30a6958c2ab584faf56fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c900011c4c21844b3a4d483e64c46d12a5c66dfc87446c12c9ad8afba8253207"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ef71ec1708158aab74396f119403682bda17d128d0ca5dbc69f029247f71a48"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "openssl@3"
  depends_on "opus"
  depends_on "pkgconf"

  uses_from_macos "zlib"

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
