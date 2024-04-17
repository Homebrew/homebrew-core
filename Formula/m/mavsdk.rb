class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https://mavsdk.mavlink.io"
  url "https://github.com/mavlink/MAVSDK.git",
      tag:      "v2.8.1",
      revision: "31f80f6fd0d5511348e9787a570bd13ecb8e9f46"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b5a46af4e21e3040b749d60cee65dd28d20a1da190a2d0267a2f33867736abcc"
    sha256 cellar: :any,                 arm64_ventura:  "41bce8fb5d30f2ab749e1a338f7bf05a6b9802218fdf381bf8ead234b5a36a6c"
    sha256 cellar: :any,                 arm64_monterey: "1987d5f6646f3fbbef031e92a5eb7817ba9b5f9658e9e16759301555e70a607e"
    sha256 cellar: :any,                 sonoma:         "ccee01454eefaf43eacbfce0aef4bd7f4131f402b3f640ee4b482621d0acc3af"
    sha256 cellar: :any,                 ventura:        "1aab66e07e5567b1b9336b449bc8d8d66019b3e91f7df614022f7fca524c0612"
    sha256 cellar: :any,                 monterey:       "fea49a695a10f6f5f0ee27a79f8a8137b144771d311684a77311c4d9b67d9056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "844b5b9cf15bd9c3451144c9176045954ab9138c0df97cd069861ea5d1f59e3f"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "curl"
  depends_on "grpc"
  depends_on "jsoncpp"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"
  depends_on "tinyxml2"

  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::__status(std::__1::__fs::filesystem::path const&, std::__1::error_code*)"
    EOS
  end

  fails_with gcc: "5"

  # MAVLINK_GIT_HASH in https://github.com/mavlink/MAVSDK/blob/v#{version}/third_party/mavlink/CMakeLists.txt
  resource "mavlink" do
    url "https://github.com/mavlink/mavlink.git",
        revision: "9840105a275db1f48f9711d0fb861e8bf77a2245"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # Fix version being reported as `v#{version}-dirty`
    inreplace "CMakeLists.txt", "OUTPUT_VARIABLE VERSION_STR", "OUTPUT_VARIABLE VERSION_STR_IGNORED"

    # Regenerate files to support newer protobuf
    system "tools/generate_from_protos.sh"

    resource("mavlink").stage do
      system "cmake", "-S", ".", "-B", "build",
                      "-DPython_EXECUTABLE=#{which("python3.12")}",
                      *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    # Source build adapted from
    # https://mavsdk.mavlink.io/develop/en/contributing/build.html
    system "cmake", "-S", ".", "-B", "build",
                    "-DSUPERBUILD=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DBUILD_MAVSDK_SERVER=ON",
                    "-DBUILD_TESTS=OFF",
                    "-DVERSION_STR=v#{version}-#{tap.user}",
                    "-DCMAKE_PREFIX_PATH=#{libexec}",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Force use of Clang on Mojave
    ENV.clang if OS.mac?

    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <mavsdk/mavsdk.h>
      using namespace mavsdk;
      int main() {
          Mavsdk mavsdk{Mavsdk::Configuration{Mavsdk::ComponentType::GroundStation}};
          std::cout << mavsdk.version() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", testpath/"test.cpp", "-o", "test",
                    "-I#{include}", "-L#{lib}", "-lmavsdk"
    assert_match "v#{version}-#{tap.user}", shell_output("./test").chomp

    assert_equal "Usage: #{bin}/mavsdk_server [Options] [Connection URL]",
                 shell_output("#{bin}/mavsdk_server --help").split("\n").first
  end
end
