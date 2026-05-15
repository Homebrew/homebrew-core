class ProtobufAT33 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v33.6/protobuf-33.6.tar.gz"
  sha256 "16498d7dc7967e9b100632138babd4b86b61592beeccdd556f67539d9c231355"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(33(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ba6d9b9093a2c49d63a46d9634ef1912a54e948b76aa6629a9ea115b4803edb6"
    sha256 cellar: :any, arm64_sequoia: "f48cc7efa525c827f13b511718baba2c04507d7652514fe143c3a4de31e39e32"
    sha256 cellar: :any, arm64_sonoma:  "8f2f8d9f4aa33ac1516586ad7d8e2ea91152ff7aba6d3ef210494aef5f6e3d6c"
    sha256 cellar: :any, sonoma:        "43f4fd87633f858bb7943468e0bd7e43fd581a26f41b61b6a2b2a3c8315a6360"
    sha256               arm64_linux:   "45249c794362b7b69c38df8bfc79c3dd3e9db3ab388780a8a25532915d96abb5"
    sha256               x86_64_linux:  "d25526aac6e5c63ee518f78c806f45d22ed65d09fd97ad638cef160f6d28a3d2"
  end

  keg_only :versioned_formula

  # Support for protoc 33.x (protobuf C++ 6.33.x) will end on 2027-03-31
  # Ref: https://protobuf.dev/support/version-support/#cpp
  deprecate! date: "2027-03-31", because: :versioned_formula

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "abseil"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
