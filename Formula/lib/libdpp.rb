class Libdpp < Formula
  desc "C++ Discord API Bot Library"
  homepage "https://github.com/brainboxdotcc/DPP"
  url "https://github.com/brainboxdotcc/DPP/releases/download/v10.0.32/DPP-10.0.32.tar.gz"
  sha256 "b366c0eb05539208e8d6c81f59de87b2aa6158250968d1bd6360676d576851e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d977977d4ac22288d30548b82e3358f494b5d6f64e51d370c4f8df06f1ecc924"
    sha256 cellar: :any,                 arm64_sonoma:  "4656e6702663a308e57643ee4feb5bd746d2bbc2ff06445bf3f01e3c2e4f3921"
    sha256 cellar: :any,                 arm64_ventura: "e8f4483d710c3c98738b62140becaad0aeb2017dce8732f6d9ceeba2422b64a5"
    sha256 cellar: :any,                 sonoma:        "3ec206aabfffc6de9c3511cf1a069b3e6d631fef0688ea681d1729969dc17a7e"
    sha256 cellar: :any,                 ventura:       "e50da46249ae37dd800a7ffc8a8448226fcacfe9a80568669fec87d4bb96c977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5973b055af4262f2c7cc1f91a92039fd32f896bcabd0f778e00b0272e6345cf"
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
