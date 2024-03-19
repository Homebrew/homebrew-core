class Libdpp < Formula
  desc "C++ Discord API Bot Library"
  homepage "https://github.com/brainboxdotcc/DPP"
  url "https://github.com/brainboxdotcc/DPP/releases/download/v10.0.29/DPP-10.0.29.tar.gz"
  sha256 "a37e91fbdabee20cb0313700588db4077abf0ebabafe386457d999d22d2d0682"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dda605c23bbe8e275ddc19c3c3001f9d7e3f1e83d6eabcfc3e82c55ac94d0770"
    sha256 cellar: :any,                 arm64_ventura:  "3af540a86d5500abefcdca59d0731235e6613b93d6c7e26201d89e726b2182e1"
    sha256 cellar: :any,                 arm64_monterey: "d5e2af4f3e84a6a1ae90c976c572befe40ef21448ffb1bd84e40065552ff575d"
    sha256 cellar: :any,                 sonoma:         "4a1db5acf4133ee9918f2ef6d852ca9d5e08281d3a993479051e552d3ce7895f"
    sha256 cellar: :any,                 ventura:        "4a23ba9b60a73ac16c9030c3bb90555d53c1c0fa1600cbbf21ad9981b9336a40"
    sha256 cellar: :any,                 monterey:       "6688c7457044aa75e9a8015ddcc7810afe79c9fb8d30bb8a6c449c24af2afbe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dea2f46dc96b176b625aca57633da0f6ada2489502671e2693cf81fc45c8c25a"
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
