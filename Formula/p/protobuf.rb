class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v27.3/protobuf-27.3.tar.gz"
  sha256 "1535151efbc7893f38b0578e83cac584f2819974f065698976989ec71c1af84a"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5b1a2146d54650db79fa06d4f412d27234b6c2cefb2a9732e082e72a962d7321"
    sha256 cellar: :any,                 arm64_ventura:  "75e04018736e21d729817cc9b008a8088548566d959f675b9c28939a05da5868"
    sha256 cellar: :any,                 arm64_monterey: "a823df91e5e83440abf17d57fea72f0c234e4d6e04ac2b0de9303c2477f07625"
    sha256 cellar: :any,                 sonoma:         "d4d402e7c17fd7f5c383058c60ab564647532ad3b26525b9f7a8f69cb0f0eb16"
    sha256 cellar: :any,                 ventura:        "3597daa5939a38c4b68df3067762f9227952e1a456f3e17a5764c89b825a767a"
    sha256 cellar: :any,                 monterey:       "79d9cbad2a7a907e73605a803bb6cb88535ec50cf3a9a1e8b4547f6cccaa437c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b4d12f9f02438f92cd3eb4e44b914fc1ef54737285f324d5e4f89307b6dcff5"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  uses_from_macos "zlib"

  on_macos do
    # We currently only run tests on macOS.
    # Running them on Linux requires rebuilding googletest with `-fPIC`.
    depends_on "googletest" => :build
  end

  def install
    # Keep `CMAKE_CXX_STANDARD` in sync with the same variable in `abseil.rb`.
    abseil_cxx_standard = 17
    cmake_args = %W[
      -DBUILD_SHARED_LIBS=ON
      -Dprotobuf_BUILD_LIBPROTOC=ON
      -Dprotobuf_BUILD_SHARED_LIBS=ON
      -Dprotobuf_INSTALL_EXAMPLES=ON
      -Dprotobuf_BUILD_TESTS=#{OS.mac? ? "ON" : "OFF"}
      -Dprotobuf_USE_EXTERNAL_GTEST=ON
      -Dprotobuf_ABSL_PROVIDER=package
      -Dprotobuf_JSONCPP_PROVIDER=package
    ]
    cmake_args << "-DCMAKE_CXX_STANDARD=#{abseil_cxx_standard}"

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build", "--verbose" if OS.mac?
    system "cmake", "--install", "build"

    (share/"vim/vimfiles/syntax").install "editors/proto.vim"
    elisp.install "editors/protobuf-mode.el"
  end

  test do
    testdata = <<~EOS
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    EOS
    (testpath/"test.proto").write testdata
    system bin/"protoc", "test.proto", "--cpp_out=."
  end
end
