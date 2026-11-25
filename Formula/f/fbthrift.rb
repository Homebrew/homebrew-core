class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/meta/fbthrift"
  url "https://github.com/meta/fbthrift/archive/refs/tags/v2026.11.23.00.tar.gz"
  sha256 "83255fcddbab9165590d272685695dd3c07a3cefcc3ac4bf69142eaa1e089063"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/meta/fbthrift.git", branch: "main"

  bottle do
    manifest_sha256 "db8ee8ffe5cf2908dc9b233919fbd77e0f9fe18266d844a9cea402a03f8ad5bc"
    sha256 cellar: :any, arm64_golden_gate: "abe6a2e8066fe7dc783ab79e4ecc793544c0fe89e91d9d062e268655820a19b0"
    sha256 cellar: :any, arm64_tahoe:       "d3ab79e55c808f3f528c772d63b8b0578906ec4b9abc8b2e4182aa580128c48a"
    sha256 cellar: :any, arm64_sequoia:     "6b5fe80a1f8bff1f6cea90beb91ad96951e3d4de1e7113f23d12e14b281ade10"
    sha256 cellar: :any, arm64_linux:       "35420320d823f0e47a17e785d81247f8f453c3ac119cbc57398b321dcd05608b"
    sha256 cellar: :any, x86_64_linux:      "c73986466bc1b182eef0862a2622bc88beeed73c2904fdea2675975e6811dc5a"
  end

  depends_on "boost" => :build
  depends_on "cmake" => [:build, :test]
  depends_on "mvfst" => [:build, :test]
  depends_on "zstd" => :build
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@4"
  depends_on "wangle"
  depends_on "xxhash"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "thrift", because: "both install `thrift` binaries"

  deny_network_access!

  def install
    ENV["OPENSSL_ROOT_DIR"] = dep("openssl").opt_prefix

    # The static libraries are a bit annoying to build. If modifying this formula
    # to include them, make sure `bin/thrift1` links with the dynamic libraries
    # instead of the static ones (e.g. `libcompiler_base`, `libcompiler_lib`, etc.)
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}", "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"]
    if OS.mac?
      shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup -Wl,-dead_strip_dylibs"
      shared_args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs"
    end

    system "cmake", "-S", ".", "-B", "build", *shared_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    elisp.install "thrift/contrib/thrift.el"
    (share/"vim/vimfiles/syntax").install "thrift/contrib/thrift.vim"

    # Save a copy of FindxxHash.cmake to test with as it is used in FBThriftConfig.cmake
    (libexec/"cmake").install "tool/fbcode_builder/CMake/FindXxhash.cmake"
  end

  test do
    (testpath/"example.thrift").write <<~THRIFT
      namespace cpp tamvm

      service ExampleService {
        i32 get_number(1:i32 number);
      }
    THRIFT

    system bin/"thrift1", "--gen", "mstch_cpp2", "example.thrift"
    assert_path_exists testpath/"gen-cpp2"
    assert_predicate testpath/"gen-cpp2", :directory?

    # TODO: consider adding an actual test
    (testpath/"test.cpp").write "int main() { return 0; }\n"

    # Test CMake package to make sure required dependencies without linkage are kept,
    # Link to `FBThrift::transport` as it uses path to `zstd` shared library
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test LANGUAGES CXX)

      list(APPEND CMAKE_MODULE_PATH "#{formula_opt_libexec("fizz")}/cmake")
      list(APPEND CMAKE_MODULE_PATH "#{opt_libexec}/cmake")
      find_package(gflags REQUIRED)
      find_package(FBThrift CONFIG REQUIRED)

      add_executable(test test.cpp)
      target_link_libraries(test FBThrift::transport)
    CMAKE

    ENV.append_path "CMAKE_PREFIX_PATH", dep("openssl").opt_prefix
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
  end
end
