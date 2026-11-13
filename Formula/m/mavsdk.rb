class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https://mavsdk.mavlink.io/main/en/index.html"
  url "https://github.com/mavlink/MAVSDK.git",
      tag:      "v4.2.0",
      revision: "2da0f3f85f0cd1ed12f981dcac17b647030186f0"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3e3cd58d063dde3881768ef2c87f128e945b4d587f6e2b53bb653e71ddc52451"
    sha256 cellar: :any, arm64_tahoe:       "2cc4fe53f428938c6cf76f0de2f4d38b82a3868163f9de8546ceb8ea2830520e"
    sha256 cellar: :any, arm64_sequoia:     "5c6c1dd8de67a3a54e61cdca13e03fa7917d8b5f4a7e0e83386f15ebfadd6b7f"
    sha256               arm64_linux:       "a6c8f73d0e07e35d92847ac728aeacbe93cc3c1665bda98d35abd342d88ac547"
    sha256               x86_64_linux:      "7d34b1f543eab68502befd49c315465e094fd52096395c8b78fbd4987fc9aef5"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "curl"
  depends_on "fmt"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "openssl@4"
  depends_on "protobuf"
  depends_on "re2"
  depends_on "tinyxml2"
  depends_on "xz"

  uses_from_macos "python" => :build

  on_macos do
    # `cpp/tools/generate_from_protos.sh` uses `mapfile`, which needs Bash 4
    depends_on "bash" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Git is required to fetch submodules
  resource "mavlink" do
    url "https://github.com/mavlink/mavlink.git",
        revision: "87da370c02e40f6f9a2eacf1b162d7f07e640467"
    version "87da370c02e40f6f9a2eacf1b162d7f07e640467"

    livecheck do
      url "https://raw.githubusercontent.com/mavlink/MAVSDK/refs/tags/v#{LATEST_VERSION}/cpp/third_party/CMakeLists.txt"
      regex(/MAVLINK_HASH.*(\h{40})/i)
    end
  end

  resource "libmavlike" do
    url "https://github.com/julianoes/libmavlike.git",
        revision: "1fa194035bf309ddeba3e12890d1c161c790a0b1"
    version "1fa194035bf309ddeba3e12890d1c161c790a0b1"

    livecheck do
      url "https://raw.githubusercontent.com/mavlink/MAVSDK/refs/tags/v#{LATEST_VERSION}/cpp/third_party/CMakeLists.txt"
      regex(/LIBMAVLIKE_HASH.*(\h{40})/i)
    end
  end

  # For `generate_from_protos` script
  # and `mavlink` which downloads PyPI packages
  allow_network_access! :build

  def install
    # Fix version being reported as `v#{version}-dirty`
    inreplace "cpp/CMakeLists.txt", "OUTPUT_VARIABLE VERSION_STR", "OUTPUT_VARIABLE VERSION_STR_IGNORED"

    # Regenerate files to support newer protobuf
    system "tools/generate_from_protos.bash"

    # `mavlink` and `libmavlike` repo and hash info moved to
    # `third_party/CMakeLists.txt` only for SUPERBUILD, so we have to manage
    # the hash manually, but then it is better to keep it as a resource.
    (buildpath/"cpp/third_party/mavlink").install resource("mavlink")
    (buildpath/"cpp/third_party/libmavlike").install resource("libmavlike")

    %w[mavlink picosha2 libevents libmavlike].each do |dep|
      system "cmake", "-S", "cpp/third_party/#{dep}", "-B", "build_#{dep}",
                      "-DMAVLINK_DIALECT=ardupilotmega",
                      "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
                      *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build_#{dep}"
      system "cmake", "--install", "build_#{dep}"
    end

    # Install MAVLink message definitions manually
    messages_files = "{minimal,standard,common,ardupilotmega}.xml"
    messages_dir = Dir["#{buildpath}/cpp/third_party/mavlink/message_definitions/v1.0/#{messages_files}"]
    (libexec/"include/mavlink/message_definitions/v1.0").install messages_dir

    # Source build adapted from
    # https://mavsdk.mavlink.io/main/en/cpp/guide/build.html
    args = %W[
      -DSUPERBUILD=OFF
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_MAVSDK_SERVER=ON
      -DBUILD_TESTING=OFF
      -DVERSION_STR=v#{version}-#{tap.user}
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DDEPS_INSTALL_PATH=#{libexec}
    ]

    system "cmake", "-S", "cpp", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <mavsdk/mavsdk.hpp>
      using namespace mavsdk;
      int main() {
          Mavsdk mavsdk{Mavsdk::Configuration{ComponentType::GroundStation}};
          std::cout << mavsdk.version() << std::endl;
          return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lmavsdk"
    assert_match "v#{version}-#{tap.user}", shell_output("./test").chomp

    assert_equal "Usage: #{bin}/mavsdk_server [Options] [Connection URL]",
                 shell_output("#{bin}/mavsdk_server --help").split("\n").first
  end
end
