class Libdpp < Formula
  desc "C++ Discord API Bot Library"
  homepage "https://dpp.dev/"
  url "https://github.com/brainboxdotcc/DPP/archive/refs/tags/v10.1.5.tar.gz"
  sha256 "0446993c2bca5fc40882386804598b33652fc7ee466fa237f7846f2be0cb8a1e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "52721d668fe65274b79c71fcba6b77ede190f532b2858ab6bcc72b929db97f78"
    sha256 cellar: :any,                 arm64_sequoia: "2a34e475d821eee082988e14d8e8f1494018718b5af4804331977ce0062fd2f2"
    sha256 cellar: :any,                 arm64_sonoma:  "174111ad5af6951d8f57663c55320fff08961394e0701857cc5db2b30d5441d1"
    sha256 cellar: :any,                 sonoma:        "31178f47a6a9c68dc541b281c3b9cee3873192482338682ad9cfc21f317709dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "169f138525e538ae77dd3a5bbaf97b0c80eb2e72b2f4e829df680144ebcfbb9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d822ac5d4a864aa85d87f17070cae0e8e1da12668540398648fd6746ad64fa8"
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
