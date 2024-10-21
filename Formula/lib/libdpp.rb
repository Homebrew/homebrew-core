class Libdpp < Formula
  desc "C++ Discord API Bot Library"
  homepage "https://github.com/brainboxdotcc/DPP"
  url "https://github.com/brainboxdotcc/DPP/releases/download/v10.0.33/DPP-10.0.33.tar.gz"
  sha256 "75ee7b32c9d46bde6d02b46b3a907302865a4ee4a965ef8a575b7417bb0a46fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b74d20fca81278d8e2782cb62d544345bbb30576121b95d7235c808acf90451f"
    sha256 cellar: :any,                 arm64_sonoma:  "72d1ae4dc59cf54b92c9f3fbaa2268d4b6d84fedb27edbc5f43fa99363253128"
    sha256 cellar: :any,                 arm64_ventura: "d85ca68f2f50e343d1819b04a9743d11253d814eb33b4b2d93deef6b2ddce79d"
    sha256 cellar: :any,                 sonoma:        "82c15d119900c2fb27f175303db49078b2c719ad3aca726ba44ced02ff54d79f"
    sha256 cellar: :any,                 ventura:       "41e03eef9b54f4c66c6fa4fde6e840ffc0ae441e6d16d759166c5fd218ea981f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27afd26ce4fa887dcc24922061c97e77089f55231abf569a424a46ae43aef998"
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
