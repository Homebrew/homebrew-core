class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https://mavsdk.mavlink.io"
  url "https://github.com/mavlink/MAVSDK.git",
      tag:      "v3.10.2",
      revision: "fb2b989b5b9849358bf9c2cb082f496d55edf173"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "8ac644b5415b2b2e655f8474641b1075b9580e916aa3bef11fefa4dbb4861114"
    sha256               arm64_sequoia: "48b4cc33d1043003dc4a9bc0c188580be125994f15371e073b003ec4cca5dd2e"
    sha256               arm64_sonoma:  "57918068d2fe00675a44d265715ee8397fe827e2c75e55f693e435469e517f04"
    sha256 cellar: :any, sonoma:        "3df9c510871577eb0c17ec22f595e262feae088384b61414887ad238d15fa7ed"
    sha256               arm64_linux:   "eab82e554754fd4987925f4bb5930c130f416afb06eaf8ba4fc84a02bf19ef9c"
    sha256               x86_64_linux:  "9dadc0d82cfbc9ff7c445e1554f66505c2e583c32b86873cf87d988458e32890"
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

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # Fix version being reported as `v#{version}-dirty`
    inreplace "CMakeLists.txt", "OUTPUT_VARIABLE VERSION_STR", "OUTPUT_VARIABLE VERSION_STR_IGNORED"

    # Regenerate files to support newer protobuf
    system "tools/generate_from_protos.sh"

    %w[mavlink picosha2 libmavlike].each do |dep|
      system "cmake", "-S", "third_party/#{dep}", "-B", "build_#{dep}", *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build_#{dep}"
      system "cmake", "--install", "build_#{dep}"
    end

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
