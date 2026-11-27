class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https://mavsdk.mavlink.io/main/en/index.html"
  url "https://github.com/mavlink/MAVSDK.git",
      tag:      "v4.3.0",
      revision: "76eda3559e20e879ff47d1123bfc716803b1a5dd"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "7f2e06a41c187c8d3ea0738e0bd19c20edb38486f8cfea77ade98be87d1705f9"
    sha256 cellar: :any, arm64_golden_gate: "8f5207e7a3ceb66192e0a540a91bde7db816a371599dcc037c82d0d0cf4687d7"
    sha256 cellar: :any, arm64_tahoe:       "60ba2d32dbb69dac31abcc242ef95569c1b4498e96de608280369a6e46d0e747"
    sha256 cellar: :any, arm64_sequoia:     "1032f6f19c2ec52b3eeba6b3a6271dd0219efe95434c6fc23ca158bba7f5dc43"
    sha256               arm64_linux:       "01c3303352f2b1f70f5a24d089913a3189de9f4aa8ce5f3669a08bb8a8f8b002"
    sha256               x86_64_linux:      "2d966728fa5d818cfd96fff865e3c248b024aa9cc2c7ca4aae2ca5881f5b1303"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "abseil"
  depends_on "curl"
  depends_on "fmt"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "protobuf"
  depends_on "tinyxml2"
  depends_on "xz"

  uses_from_macos "python" => :build

  on_macos do
    # `cpp/tools/generate_from_protos.sh` uses `mapfile`, which needs Bash 4
    depends_on "bash" => :build
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
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

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
