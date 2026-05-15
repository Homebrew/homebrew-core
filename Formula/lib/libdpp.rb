class Libdpp < Formula
  desc "C++ Discord API Bot Library"
  homepage "https://github.com/brainboxdotcc/DPP"
  url "https://github.com/brainboxdotcc/DPP/archive/refs/tags/v10.1.4.tar.gz"
  sha256 "f11b6d3fc5cc8febcf672b573ca74293ead6c6ea48a66ac0316ab9a5cbd09441"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "ed4381735ffe387ad60865f7c1097d9814a81d32ff40e02441cc06f98fc54a5e"
    sha256 cellar: :any,                 arm64_sequoia: "fcc5344b1764a84cbd1278f8e6b4eb7d8701ddd705d4ca6fac097c347c44e689"
    sha256 cellar: :any,                 arm64_sonoma:  "d8ef8e060fc8d453cd1dda3504682fa14964e50b4007b646229e1bf4726a034f"
    sha256 cellar: :any,                 sonoma:        "daf05786e8cba8e07e9e26e8cdd10f9c8503538c4d33b755e2b79e8f2d1285dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cacb6b011fc2123d3e09824694b2f54c902b7918f8e6b2929afe89e03b2696e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "447038751ce0cd976352472c2ce51c945c9e26317b15bfb6ed35866699b591d8"
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
