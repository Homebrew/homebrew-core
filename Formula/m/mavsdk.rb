class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https://mavsdk.mavlink.io/main/en/index.html"
  url "https://github.com/mavlink/MAVSDK.git",
      tag:      "v3.11.2",
      revision: "a25fd153f92a7572c4bb6964bfcdbc7ba96e0892"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "30b7b4238767d5941bd4f4353cea2dfd51a7db89c34e18d79c96dfbc5cba0d8d"
    sha256               arm64_sequoia: "e7c44e6102e43565a47696a98281eb363837acb2adacd5d1667c7497d8a4a0d6"
    sha256               arm64_sonoma:  "8ee910c8c16ce19f6cc53c2f32d354f0260d9217a9cf983ac08ba1aeb5876734"
    sha256 cellar: :any, sonoma:        "f87acf1a01a612d18c2e41d3cccba50321451ece27278387d7969d566bd31aa1"
    sha256               arm64_linux:   "3b8ab75d1ce97f6f04c14bec143152df9673d396448e163f660598e7d1765e18"
    sha256               x86_64_linux:  "70f4809b7eaaf5f238eeca8066f264a941b478e1fcd72071bfcc60c6da488533"
  end

  depends_on "cmake" => :build
  depends_on "python@3.14" => :build
  depends_on "rust" => :build
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

  # Git is required to fetch submodules
  resource "mavlink" do
    url "https://github.com/mavlink/mavlink.git",
        revision: "d6a7eeaf43319ce6da19a1973ca40180a4210643"
    version "d6a7eeaf43319ce6da19a1973ca40180a4210643"

    livecheck do
      url "https://raw.githubusercontent.com/mavlink/MAVSDK/refs/tags/v#{LATEST_VERSION}/third_party/CMakeLists.txt"
      regex(/MAVLINK_HASH.*(\h{40})/i)
    end
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # Fix version being reported as `v#{version}-dirty`
    inreplace "CMakeLists.txt", "OUTPUT_VARIABLE VERSION_STR", "OUTPUT_VARIABLE VERSION_STR_IGNORED"

    # Regenerate files to support newer protobuf
    system "tools/generate_from_protos.sh"

    # `mavlink` repo and hash info moved to `third_party/CMakeLists.txt` only for SUPERBUILD,
    # so we have to manage the hash manually, but then it is better to keep it as a resource.
    (buildpath/"third_party/mavlink").install resource("mavlink")

    %w[mavlink picosha2 libevents libmavlike].each do |dep|
      system "cmake", "-S", "third_party/#{dep}", "-B", "build_#{dep}", *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build_#{dep}"
      system "cmake", "--install", "build_#{dep}"
    end

    # Install MAVLink message definitions manually
    messages_files = "{minimal,standard,common,ardupilotmega}.xml"
    messages_dir = Dir["#{buildpath}/third_party/mavlink/message_definitions/v1.0/#{messages_files}"]
    (libexec/"include/mavlink/message_definitions/v1.0").install messages_dir

    # Source build adapted from
    # https://mavsdk.mavlink.io/main/en/cpp/guide/build.html
    args = %W[
      -DSUPERBUILD=OFF
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_MAVSDK_SERVER=ON
      -DBUILD_TESTS=OFF
      -DVERSION_STR=v#{version}-#{tap.user}
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DDEPS_INSTALL_PATH=#{libexec}
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
