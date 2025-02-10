class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https://mavsdk.mavlink.io"
  url "https://github.com/mavlink/MAVSDK.git",
      tag:      "v3.0.0",
      revision: "e0e4ffb34a1913960f6c9ccdc8bcbea0447d26ad"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "090e7523a00b707dea82789f22670b74e4913f3bd1e19cfbeb80b88e4c224d68"
    sha256 cellar: :any,                 arm64_sonoma:  "1dbe00798046a4904177c25fb9a6050e31b77dea1ce52feec39a0ad389cf4c8c"
    sha256 cellar: :any,                 arm64_ventura: "1f4436eab9af58d423f37a7527f1234ddf9ce2427adaa2ac82fd0a6403660299"
    sha256 cellar: :any,                 sonoma:        "d99ad4184135a9fd60463296ba42bf5d73673564dc206408691620b155e2ffa0"
    sha256 cellar: :any,                 ventura:       "d4177676ac0a49b54a7b62b41ae8e03ecbef7912bbcae241973db215e8802531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e290881831198dd44a5c469790f0f08917509cfe34d460d5a0169724cb6bfd8"
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
