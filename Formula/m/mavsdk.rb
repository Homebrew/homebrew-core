class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https://mavsdk.mavlink.io/main/en/index.html"
  url "https://github.com/mavlink/MAVSDK.git",
      tag:      "v4.0.6",
      revision: "92cd383a2f58117f99afda5c96d1439d60236faa"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9a650087873b7167a9968b832ce653b969225aedd6e63454e02dd89e9800fb5a"
    sha256 cellar: :any, arm64_tahoe:       "39313fe807f3dc6ac17a8ca3a8b7016bf40bc8dce351520140c25dc01edfc69b"
    sha256 cellar: :any, arm64_sequoia:     "0558ac6becdb2709ccd8a3c5f87dd574a896ccf95807987c88c19e620e830a39"
    sha256               arm64_linux:       "a2aeb6b51b091fe717ccb427659b06fa84c831660c7cafea83f0e84d3e82fc59"
    sha256               x86_64_linux:      "70f5a18b55821dc6bd40175d2279979c99c2bb601c2b5db8e4c423726baadb0f"
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
        revision: "d6a7eeaf43319ce6da19a1973ca40180a4210643"
    version "d6a7eeaf43319ce6da19a1973ca40180a4210643"

    livecheck do
      url "https://raw.githubusercontent.com/mavlink/MAVSDK/refs/tags/v#{LATEST_VERSION}/cpp/third_party/CMakeLists.txt"
      regex(/MAVLINK_HASH.*(\h{40})/i)
    end
  end

  def install
    # Fix version being reported as `v#{version}-dirty`
    inreplace "cpp/CMakeLists.txt", "OUTPUT_VARIABLE VERSION_STR", "OUTPUT_VARIABLE VERSION_STR_IGNORED"

    # Regenerate files to support newer protobuf
    system "tools/generate_from_protos.bash"

    # `mavlink` repo and hash info moved to `third_party/CMakeLists.txt` only for SUPERBUILD,
    # so we have to manage the hash manually, but then it is better to keep it as a resource.
    (buildpath/"cpp/third_party/mavlink").install resource("mavlink")

    %w[mavlink picosha2 libevents libmavlike].each do |dep|
      system "cmake", "-S", "cpp/third_party/#{dep}", "-B", "build_#{dep}",
                      "-DMAVLINK_DIALECT=ardupilotmega",
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
