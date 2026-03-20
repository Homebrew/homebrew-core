class Libdpp < Formula
  desc "C++ Discord API Bot Library"
  homepage "https://github.com/brainboxdotcc/DPP"
  url "https://github.com/brainboxdotcc/DPP/archive/refs/tags/v10.1.4.tar.gz"
  sha256 "f11b6d3fc5cc8febcf672b573ca74293ead6c6ea48a66ac0316ab9a5cbd09441"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "c5022345a6b7fc9c4518698d511ad1487e53a295707b89368032cd9590ad32cc"
    sha256 cellar: :any,                 arm64_sequoia: "f179deb074f4384b8ae185ee2e6f6b05bbd63679838d65f8114595890bdf615d"
    sha256 cellar: :any,                 arm64_sonoma:  "babee221f0768dfd793918335a1d4fd7a862151cdc7c45d6a17d911cc448d833"
    sha256 cellar: :any,                 sonoma:        "183dff2ab83799bc9ca38c00af58bebd310959ee13912a529d2615163152bea1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "051ebf325593da2a5c1940348c1d5b2ffc5228f87402b3a4899c8a0e35b919e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77e3dfffd350f286e85ac0fd66648f92ea0a6aaaf2d5dc9136821c8f637248c3"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "openssl@3"
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
