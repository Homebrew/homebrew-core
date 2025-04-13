class Libdpp < Formula
  desc "C++ Discord API Bot Library"
  homepage "https://github.com/brainboxdotcc/DPP"
  url "https://github.com/brainboxdotcc/DPP/releases/download/v10.1.2/DPP-10.1.2.tar.gz"
  sha256 "587ef044775e6bdd560ec17afc302c1048ebb3454455116d7241431fbb16a823"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bd5ca9c17dac9e5569aa51cf3dce3c6f4a3796c131474c6e99732d9c4834ce08"
    sha256 cellar: :any,                 arm64_sonoma:  "c8ea3bc7e0797ef5c9b7d9d4c5cb2bb3772d79eb8b6ce807d3ee02d0be9cfeeb"
    sha256 cellar: :any,                 arm64_ventura: "f622d491be1b229606a29223fccb0f1a118ea0593b7074afc23e92ccfa806f9b"
    sha256 cellar: :any,                 sonoma:        "920148455d24bf5e5e9f74855ae96aaf513f63516b253a6351844014265034d7"
    sha256 cellar: :any,                 ventura:       "2da37488f353e467fc7004b609e06afe24d039fea1e48e1f9c31e54aa3bba5ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8e511ba2aa3be34220a05f641bf48aece828c0ac8d7b518b27083b1b713639b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "505666b971cc6cb3928342b78b0290f5f046374385ff69a16e3e228314300cb3"
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
