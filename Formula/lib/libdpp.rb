class Libdpp < Formula
  desc "C++ Discord API Bot Library"
  homepage "https://github.com/brainboxdotcc/DPP"
  url "https://github.com/brainboxdotcc/DPP/releases/download/v10.0.30/DPP-10.0.30.tar.gz"
  sha256 "fb7019770bd5c5f0539523536250da387ee1fa9c92e59c0bcff6c9adaf3d77e8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a0759936e0da422d6d309aeec3169885b981e48944c4efba9af5735734543957"
    sha256 cellar: :any,                 arm64_ventura:  "8d57b4ec0e3484b19ee6b8fc7dc3af8bf46dc62d44ae991c6739a692837e1087"
    sha256 cellar: :any,                 arm64_monterey: "0195d7d7cd9eb05b10fbe61f93743510a838098e4d88cfba235ee2b7e2243ad8"
    sha256 cellar: :any,                 sonoma:         "d2ebaec5d95a2820597ef5d2440c6e06a4582c1712a6ccc623bfb9391e12f5c0"
    sha256 cellar: :any,                 ventura:        "1866708cc97ad4b04d16c792239c274e70cace4b5abd7cfc0cdb832d75069635"
    sha256 cellar: :any,                 monterey:       "edd0ad267a355cd823b8e82ca622f90cdeaa4f500904085ca2a206dd30281958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67abbbb8662f9ce21445ece6a9c23e8e55e84b0f07dcb49ed8b82ea61db8bb92"
  end

  depends_on "cmake" => :build
  depends_on xcode: ["12.0", :build]
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
        catch(dpp::invalid_token_exception& e) {
          std::cout << "Invalid token." << std::endl;
          return 0;
        }
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "-L#{lib}", "-I#{include}", "test.cpp", "-o", "test", "-ldpp"
    assert_equal "Invalid token.", shell_output("./test").strip
  end
end
