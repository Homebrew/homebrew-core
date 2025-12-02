class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v33.1/protobuf-33.1.tar.gz"
  sha256 "fda132cb0c86400381c0af1fe98bd0f775cb566cb247cdcc105e344e00acc30e"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "154fbfce71a02a606688d801b42a19778c99c4037cc59ed155d9e0211df2adb9"
    sha256 cellar: :any, arm64_sequoia: "8c456db7777b569dea9b323c3ac95d6c54da49bf9aad46087615e4351e59b504"
    sha256 cellar: :any, arm64_sonoma:  "bf83b49e42c1237487e0e66b0dba7a1ab07dd424ab22fa7b7d345447427eec97"
    sha256 cellar: :any, sonoma:        "ebc9563ca65f5bf6237e58710fd8da07c9c59d4dca351e668daf687bf1628583"
    sha256               arm64_linux:   "be1aef38ea2f9585616b3e92035efd1e00d7f6c463b03006f49decf8c3a056f1"
    sha256               x86_64_linux:  "496bfa119d26ce4707f17a17e3d1e74b68a81cb9f2e738d74aead925810eae9c"
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
