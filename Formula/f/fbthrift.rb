class Fbthrift < Formula
  desc "Facebook's branch of Apache Thrift, including a new C++ server"
  homepage "https://github.com/facebook/fbthrift"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/facebook/fbthrift.git", branch: "main"

  stable do
    url "https://github.com/facebook/fbthrift/archive/refs/tags/v2026.03.16.00.tar.gz"
    sha256 "b79411e8e8c86ec98577e68b79e0889d53bda0d1ef45ffd7f839a776e87784f3"

    # Backport fix for shared libraries
    patch do
      url "https://github.com/facebook/fbthrift/commit/ea92c7a50d7058475559790717fceef975325a4c.patch?full_index=1"
      sha256 "7b48afa014ab190296847386901705bcda066ea4ff8b6eca16366d7cb8bb6c98"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "da098e7856a91706e9054a2ea60fc0b9cc7eebf28f5db72c7cc8775372a8aada"
    sha256 cellar: :any,                 arm64_sequoia: "beaf8b33d4a1cea830c40584f7f5ee2f7fa4a7bbf9dab8cda399231c0b3c67c1"
    sha256 cellar: :any,                 arm64_sonoma:  "dd2d4a11083bf92c73ab698e1fa4d456ae935803e5456794be31f2a79c4174a6"
    sha256 cellar: :any,                 sonoma:        "e0f6f493e185175b49be075a5ade32e45a245e8117c516ab2c0e39cce98946c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "021dfd1ca8324f19207d32ad7bd17e3ecfa0e80d8cd7157f1c13662287264336"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e696a29e69245b68298ad71d17c43a7a7be876f6930cdc40ccc0f0da6f06472"
  end

  depends_on "bison" => :build # Needs Bison 3.1+
  depends_on "cmake" => [:build, :test]
  depends_on "mvfst" => [:build, :test]
  depends_on "zstd" => :build
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "xxhash"

  uses_from_macos "flex" => :build
  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  on_linux do
    depends_on "boost"
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1100
    cause "error: 'asm goto' constructs are not supported yet"
  end

  def install
    # Work around build failure with Xcode 16
    # Issue ref: https://github.com/facebook/fbthrift/issues/618
    # Issue ref: https://github.com/facebook/fbthrift/issues/607
    ENV.append "CXXFLAGS", "-fno-assume-unique-vtables" if DevelopmentTools.clang_build_version >= 1600

    ENV["OPENSSL_ROOT_DIR"] = Formula["openssl@3"].opt_prefix

    # The static libraries are a bit annoying to build. If modifying this formula
    # to include them, make sure `bin/thrift1` links with the dynamic libraries
    # instead of the static ones (e.g. `libcompiler_base`, `libcompiler_lib`, etc.)
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}", "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"]
    if OS.mac?
      shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup -Wl,-dead_strip_dylibs"
      shared_args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs"
    end

    # We build in-source to avoid an error from thrift/lib/cpp2/test:
    # Output path .../build/shared/thrift/lib/cpp2/test/../../../conformance/if is unusable or not a directory
    system "cmake", "-S", ".", "-B", ".", *shared_args, *std_cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    elisp.install "thrift/contrib/thrift.el"
    (share/"vim/vimfiles/syntax").install "thrift/contrib/thrift.vim"

    # Save a copy of FindxxHash.cmake to test with as it is used in FBThriftConfig.cmake
    (libexec/"cmake").install "build/fbcode_builder/CMake/FindXxhash.cmake"
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

      list(APPEND CMAKE_MODULE_PATH "#{Formula["fizz"].opt_libexec}/cmake")
      list(APPEND CMAKE_MODULE_PATH "#{opt_libexec}/cmake")
      find_package(gflags REQUIRED)
      find_package(FBThrift CONFIG REQUIRED)

      add_executable(test test.cpp)
      target_link_libraries(test FBThrift::transport)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
  end
end
