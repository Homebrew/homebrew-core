class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v33.4/protobuf-33.4.tar.gz"
  sha256 "bc670a4e34992c175137ddda24e76562bb928f849d712a0e3c2fb2e19249bea1"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4bff0639995cb00420302c64dda3ae9eed6de24632fb158100e3ea05827ed844"
    sha256 cellar: :any, arm64_sequoia: "67aa3f9858e52ac658dc3c27091a6be275bb618aa94b3fbcc0e52a8e2b486744"
    sha256 cellar: :any, arm64_sonoma:  "aa983aa28a537848aef4673b3d184f07ee970f9271cda474c31ab11be487756f"
    sha256 cellar: :any, sonoma:        "0c4ed6e9a1c0e917d9d29bb0e391123541b2e2e7f1cee8acff7324bbe9ae47e0"
    sha256               arm64_linux:   "9a71cdbdefb4ac6b2b7cdff448f48df64a8c2b4a41c274227c7e320e10bea0d4"
    sha256               x86_64_linux:  "38502c5697b730a7643bf04a72d01198ae494d114f11af1f0446595e9440b3a3"
  end

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
