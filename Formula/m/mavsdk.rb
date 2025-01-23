class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https://mavsdk.mavlink.io"
  url "https://github.com/mavlink/MAVSDK.git",
      tag:      "v3.0.0",
      revision: "e0e4ffb34a1913960f6c9ccdc8bcbea0447d26ad"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "24d79fd3dff6b0a58b84e247e639af4c09fb379113f66c273d8f9cda5d6b3de3"
    sha256 cellar: :any,                 arm64_sonoma:  "ecd1a55d641d7cacb89672fa1a51dbc6a5e31c8135ffbffdf964e2f69a107e1c"
    sha256 cellar: :any,                 arm64_ventura: "659bfb1624987980f03a703b511a4618e824e23381a59f14642b06af0da6656d"
    sha256 cellar: :any,                 sonoma:        "0d6e76c9ad7822e2ca953f64d9eec447a7d10388924e2c6a4c101ac7720b342c"
    sha256 cellar: :any,                 ventura:       "c2362b72f25abb9ff81e6e45f91eb834be0f0b6546f50710894d6942e26210fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51cb9d4e332deb0ae621273e10cd8557527cfa88f6a5879797751add372efc97"
  end

  depends_on "cmake" => :build
  depends_on "python@3.13" => :build
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
  # curl -s https://raw.githubusercontent.com/mavlink/MAVSDK/v$ver/third_party/mavlink/CMakeLists.txt \
  # | grep 'MAVLINK_GIT_HASH'
  resource "mavlink" do
    url "https://github.com/mavlink/mavlink.git",
        revision: "5e3a42b8f3f53038f2779f9f69bd64767b913bb8"
  end

  # macos rpath fix, upstream pr ref, https://github.com/mavlink/MAVSDK/pull/2495
  patch do
    url "https://github.com/mavlink/MAVSDK/commit/6d11efa589dbe045890c2f3a5db8091833b0f1a3.patch?full_index=1"
    sha256 "c10aa11c78281eef4326548b4cbc25fd637d709e814f62f2a3025b7d16d5af04"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # Fix version being reported as `v#{version}-dirty`
    inreplace "CMakeLists.txt", "OUTPUT_VARIABLE VERSION_STR", "OUTPUT_VARIABLE VERSION_STR_IGNORED"

    # Regenerate files to support newer protobuf
    system "tools/generate_from_protos.sh"

    resource("mavlink").stage do
      system "cmake", "-S", ".", "-B", "build",
                      "-DPython_EXECUTABLE=#{which("python3.13")}",
                      *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    # Source build adapted from
    # https://mavsdk.mavlink.io/develop/en/contributing/build.html
    args = %W[
      -DSUPERBUILD=OFF
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_MAVSDK_SERVER=ON
      -DBUILD_TESTS=OFF
      -DVERSION_STR=v#{version}-#{tap.user}
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
          Mavsdk mavsdk{Mavsdk::Configuration{ComponentType::GroundStation}};
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
