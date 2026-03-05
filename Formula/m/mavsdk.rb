class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https://mavsdk.mavlink.io/main/en/index.html"
  url "https://github.com/mavlink/MAVSDK.git",
      tag:      "v3.15.0",
      revision: "721efdc45eedfe8761ceb7280dedca6004b1ea92"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "691841d9f5458ea6f55391900c415ce93ef3c12ddd7a91ec0037c14606cf092d"
    sha256               arm64_sequoia: "bff5ec9b618e0eee76f7f5a1fa7b52a911d762da0981d5382125929b096b461c"
    sha256               arm64_sonoma:  "b4066ede7f6fb67e2a6f477f1f9213ad72dc42d89a669236f06c6bc65344a99d"
    sha256 cellar: :any, sonoma:        "d7fb36534da42fef8aa5d13e03942001dee79a2d8a264c130296083bc1f9329c"
    sha256               arm64_linux:   "38ea072769de13d9563472f2cdab865c3a182daf5165c8e5782429a94c5c1a3c"
    sha256               x86_64_linux:  "f19afe67e7206db1e4a5c232e0537f85dae9ae020a93e3b3ef59bc7cd0ff889f"
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

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
    # Fix version being reported as `v#{version}-dirty`
    inreplace "CMakeLists.txt", "OUTPUT_VARIABLE VERSION_STR", "OUTPUT_VARIABLE VERSION_STR_IGNORED"

    # Regenerate files to support newer protobuf
    system "tools/generate_from_protos.sh"

    # `mavlink` repo and hash info moved to `third_party/CMakeLists.txt` only for SUPERBUILD,
    # so we have to manage the hash manually, but then it is better to keep it as a resource.
    (buildpath/"third_party/mavlink").install resource("mavlink")

    %w[mavlink picosha2 libevents libmavlike].each do |dep|
      system "cmake", "-S", "third_party/#{dep}", "-B", "build_#{dep}",
                      "-DMAVLINK_DIALECT=ardupilotmega",
                      *std_cmake_args(install_prefix: libexec)
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
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lmavsdk"
    assert_match "v#{version}-#{tap.user}", shell_output("./test").chomp

    assert_equal "Usage: #{bin}/mavsdk_server [Options] [Connection URL]",
                 shell_output("#{bin}/mavsdk_server --help").split("\n").first
  end
end
