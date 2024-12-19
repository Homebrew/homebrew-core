class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https://mavsdk.mavlink.io"
  url "https://github.com/mavlink/MAVSDK.git",
      tag:      "v2.14.0",
      revision: "a964028c2213bb5cfdf2b29ed61e0c21c8babca6"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fd5d6731c24d5983667ee99a7588f5d592eb56dea94b5247a3cf538f964baa82"
    sha256 cellar: :any,                 arm64_sonoma:  "85e0c22b9bb05f36e204dce097c47096c0a7e38a84ff64a6117c5966088c4215"
    sha256 cellar: :any,                 arm64_ventura: "70bfd7f3b29d3b9e268d423d498f8fdc39323272226db66aae2f29480147a118"
    sha256 cellar: :any,                 sonoma:        "4ec434c2f2bd0394e697ceeb8b65c5b2f258acbcbe808872967d275f7aa458f4"
    sha256 cellar: :any,                 ventura:       "93778028e43415d0c9ffd1da5a793e65d49753cfaee1df1fb5033007eb263d13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52d402654c217589353ab704710af02e8c02a91ff0c540c4739e132caa2ad740"
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
  depends_on "xz"

  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::__status(std::__1::__fs::filesystem::path const&, std::__1::error_code*)"
    EOS
  end

  # ver={version} && \
  # curl -s https://raw.githubusercontent.com/mavlink/MAVSDK/v$ver/third_party/mavlink/CMakeLists.txt && \
  # | grep 'MAVLINK_GIT_HASH'
  resource "mavlink" do
    url "https://github.com/mavlink/mavlink.git",
        revision: "f1d42e2774cae767a1c0651b0f95e3286c587257"
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

    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <mavsdk/mavsdk.h>
      using namespace mavsdk;
      int main() {
          Mavsdk mavsdk{Mavsdk::Configuration{Mavsdk::ComponentType::GroundStation}};
          std::cout << mavsdk.version() << std::endl;
          return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", testpath/"test.cpp", "-o", "test",
                    "-I#{include}", "-L#{lib}", "-lmavsdk"
    assert_match "v#{version}-#{tap.user}", shell_output("./test").chomp

    assert_equal "Usage: #{bin}/mavsdk_server [Options] [Connection URL]",
                 shell_output("#{bin}/mavsdk_server --help").split("\n").first
  end
end
