class Libdpp < Formula
  desc "C++ Discord API Bot Library"
  homepage "https://github.com/brainboxdotcc/DPP"
  url "https://github.com/brainboxdotcc/DPP/releases/download/v10.0.35/DPP-10.0.35.tar.gz"
  sha256 "46efde92ec6aba7f3e2b7ad17af2ffa4a18fc0bf3b3566a03f7131784ff7fdc8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6ba9d843c0b55a1bd4d06054715b4c5c498b056f49d47a4b9950956e976c79d4"
    sha256 cellar: :any,                 arm64_sonoma:  "5e50bc8d8544325681519650fd73aa770ddb774d76272bdfcba88efe8efd96ba"
    sha256 cellar: :any,                 arm64_ventura: "71e4e422d2baccc8315be500444c14bcf5825cb823f5eaf9a1b17cd4d9022bb7"
    sha256 cellar: :any,                 sonoma:        "3a61a2ebcc9bae68592d37614494fb07ea138ded82d26f2cb56781378517075a"
    sha256 cellar: :any,                 ventura:       "2c41ce2640725e6f503e7bec5c4df3b7b1c4c5cdaae6643d65a472709c14c409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fffb302d055218650557cc3f06e2f454ffda90fb0f8985c9212ab48a4a782799"
  end

  depends_on "cmake" => :build
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
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "-std=c++17", "-L#{lib}", "-I#{include}", "test.cpp", "-o", "test", "-ldpp"
    assert_match "Connection error", shell_output("./test 2>&1", 1)
  end
end
