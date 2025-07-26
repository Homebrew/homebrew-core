class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https://mavsdk.mavlink.io"
  url "https://github.com/mavlink/MAVSDK.git",
      tag:      "v3.8.1",
      revision: "f5d517ef3d34fd0f7e5b2f791160f5aa5f3b60e7"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "4884a3d192059503e00cf0e7fdd50fed874ecaa98e5f193ea00f84e31e11f4f6"
    sha256                               arm64_sonoma:  "e1cdbdc6fc9c8419623663ce0d96f0468c9de2df3ae326bf229b6c690a4a4a9e"
    sha256                               arm64_ventura: "eb3e54706ef3b60bdbea39593f579b7a71136c8488242b469da89ca65cda4704"
    sha256 cellar: :any,                 sonoma:        "bfb6d7b6f67fae424c31a1215f63d6a621f812e568442975db96b35c2fb343f4"
    sha256 cellar: :any,                 ventura:       "39721886df5163f71dd54d0e68e6ec195de210209dd0e2fe929aac317c69fec6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37eac374e560f9d34cdaa933a641327c7d6165d36ee709b830e4c49ea67b0ff2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b561f0977cfe5f6f311816c1cf3a0b236dc19ab750a1e019319d1acba8ad391"
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

  # ver={version} && \
  # curl -s https://raw.githubusercontent.com/mavlink/MAVSDK/v$ver/third_party/picosha2/CMakeLists.txt \
  # | grep -A 2 GIT_REPOSITORY
  resource "picosha2" do
    url "https://github.com/julianoes/PicoSHA2.git",
        branch:   "cmake-install-support",
        revision: "1bf940d8a03bb752604fbb366d47b97b50b9e6ce"
  end

  # ver={version} && \
  # curl -s https://raw.githubusercontent.com/mavlink/MAVSDK/v$ver/third_party/libmavlike/CMakeLists.txt \
  # | grep -A 2 GIT_REPOSITORY
  resource "libmavlike" do
    url "https://github.com/julianoes/libmavlike.git",
        revision: "ccc3addc341ae907de7a2937ebf51c6ff2cd30fa"
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
      # TEST
      (libexec/"include/mavlink/message_definitions/v1.0/").install Dir["message_definitions/v1.0/*"]
    end

    resource("picosha2").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    resource("libmavlike").stage do
      args = %w[
        -DBUILD_SHARED_LIBS=OFF
        -DBUILD_TESTING=OFF
      ]
      system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_prefix: libexec)
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
