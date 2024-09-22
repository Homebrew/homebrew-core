class Libdpp < Formula
  desc "C++ Discord API Bot Library"
  homepage "https://github.com/brainboxdotcc/DPP"
  url "https://github.com/brainboxdotcc/DPP/releases/download/v10.0.31/DPP-10.0.31.tar.gz"
  sha256 "3e392868c0dc3d0f13a00cfa190a925a20bde62bea58fd87d4acf14de11062bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "caca507c748a87343aa57cd401b3f6a877908a871067150214aaa7886dd3f6b4"
    sha256 cellar: :any,                 arm64_sonoma:  "02a2eb1a65915b5c94149c61def6885f535d79ef5bfb06bc1c99d15594da4e07"
    sha256 cellar: :any,                 arm64_ventura: "d34a8ba6bfea8971c54f047f53605c96e2573efe011ff7d73be71eca6e2ef82a"
    sha256 cellar: :any,                 sonoma:        "6f6367a163706da5ecd97e9bd9a75748f4564b3652b6323638d1aec7ea85e41d"
    sha256 cellar: :any,                 ventura:       "2c8a3d92988233d81fb220951b0e0bc45b59761af50941cf34225b1beeb65de4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37a8a895a2484c52498d2e35f151224a5050345fa516abaedf8c368e91550312"
  end

  depends_on "cmake" => :build
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "opus"
  depends_on "pkg-config"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DDPP_CORO=on", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <dpp/dpp.h>

      int main() {
        dpp::cluster bot("invalid_token");

        bot.on_log(dpp::utility::cout_logger());

        try {
          bot.start(dpp::st_wait);
        }
        catch (const dpp::connection_exception& e) {
          std::cout << "Connection error: " << e.what() << std::endl;
          return 1;
        }
        catch(dpp::invalid_token_exception& e) {
          std::cout << "Invalid token." << std::endl;
          return 1;
        }
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "-L#{lib}", "-I#{include}", "test.cpp", "-o", "test", "-ldpp"
    assert_match "Connection error", shell_output("./test 2>&1", 1)
  end
end
