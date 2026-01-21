class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v33.4/protobuf-33.4.tar.gz"
  sha256 "bc670a4e34992c175137ddda24e76562bb928f849d712a0e3c2fb2e19249bea1"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "36d36efccf5a514d46b81d9719bd185644ff6a228862096e1a60a98060e08b35"
    sha256 cellar: :any, arm64_sequoia: "eb4d37b99bc6d8769c5bad17bf4fd79abc6108c5a68997b91ae117404f62ef42"
    sha256 cellar: :any, arm64_sonoma:  "0fc269052b938715697ae849ffc2e46f196a88b0f1790725c7e486e78e5bbb59"
    sha256 cellar: :any, sonoma:        "3a5b7d66a76d15a84e7615dca3826a0a0722cf35c9cc2d01623de37251d329dc"
    sha256               arm64_linux:   "5cf2bd6de03a95be0bfe53dcfb20b622f1b8a1ab3a425f463483c18af7d31f3d"
    sha256               x86_64_linux:  "1f9161269399b70e869c94aa18e62702cdacde0e64b26d1e8858bcabc72dc7a0"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "abseil"
  uses_from_macos "zlib"

  def install
    # Keep `CMAKE_CXX_STANDARD` in sync with the same variable in `abseil.rb`.
    abseil_cxx_standard = 17
    cmake_args = %W[
      -DCMAKE_CXX_STANDARD=#{abseil_cxx_standard}
      -DBUILD_SHARED_LIBS=ON
      -Dprotobuf_BUILD_LIBPROTOC=ON
      -Dprotobuf_BUILD_SHARED_LIBS=ON
      -Dprotobuf_INSTALL_EXAMPLES=ON
      -Dprotobuf_BUILD_TESTS=ON
      -Dprotobuf_USE_EXTERNAL_GTEST=ON
      -Dprotobuf_FORCE_FETCH_DEPENDENCIES=OFF
      -Dprotobuf_LOCAL_DEPENDENCIES_ONLY=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build", "--verbose"
    system "cmake", "--install", "build"

    (share/"vim/vimfiles/syntax").install "editors/proto.vim"
    elisp.install "editors/protobuf-mode.el"
  end

  test do
    (testpath/"test.proto").write <<~PROTO
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    PROTO
    system bin/"protoc", "test.proto", "--cpp_out=."
  end
end
