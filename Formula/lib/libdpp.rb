class Libdpp < Formula
  desc "C++ Discord API Bot Library"
  homepage "https://github.com/brainboxdotcc/DPP"
  url "https://github.com/brainboxdotcc/DPP/archive/refs/tags/v10.1.3.tar.gz"
  sha256 "a32d94dcd6b23430afff82918234e4e28e0616bd2ddf743c5ab2f1778c5a600b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "60f30087bbd2163b424e7cd0c5121179449e4a4da026a1b17dafcc59abb1be36"
    sha256 cellar: :any,                 arm64_sequoia: "ddc7973cf1ac5476c7fa54a2114a44b96822ccc8014217d4fc5eaf0d12753752"
    sha256 cellar: :any,                 arm64_sonoma:  "716410144df8562e95571a6e1312bee9f4a22d9859ebf3b9a6feb62681917ca2"
    sha256 cellar: :any,                 arm64_ventura: "930866492ac48f28e53f750da08afb3f60fe135b344e78f7aec20ebb47248065"
    sha256 cellar: :any,                 sonoma:        "d8bffea263432cb8387895e869d453cb1a2766275a92937392e2f774bb2207de"
    sha256 cellar: :any,                 ventura:       "e802c41a7832725d8dc8a308deb9369d7c3191fdd099e8a7898ab65af2cec11a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "619c395f2ee566b0993475a995f522262b21b2121d25bd3478a9f09510a02533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbd8551af03bb02344fe511a9757df305d2997e90a1d5cbb4e3b516c4dbd7fae"
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
