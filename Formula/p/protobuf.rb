class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v32.1/protobuf-32.1.tar.gz"
  sha256 "3feeabd077a112b56af52519bc4ece90e28b4583f4fc2549c95d765985e0fd3c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0a9e0257f899e4f2cd72e5785c653d7ea530a576502ed9db1a5a11b819871800"
    sha256 cellar: :any, arm64_sequoia: "b5a067f85f83be3bb590c18c221f59a828de1f09abe9e9a2c7edfb58f6294bcf"
    sha256 cellar: :any, arm64_sonoma:  "c428de31aa824c89a790865d1df70fed74b686f3db4e74de07a247b8b72eafb7"
    sha256 cellar: :any, sonoma:        "12040092975230c2eda4db4aeabc75f07cd64b30458fe6dc775bd52a44694967"
    sha256               arm64_linux:   "832fc339ac68efbeea47cb71efac4e0c1c001c277b8ebcdc715ec358296a5128"
    sha256               x86_64_linux:  "f4ba1e959a4d7ee36114aa689e1469a7e2b5c5df319a684263350da52698af63"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "abseil"
  uses_from_macos "zlib"

  # Apply open PR to fix CRC32 usage on arm64 linux
  # https://github.com/protocolbuffers/protobuf/pull/23164
  patch do
    url "https://github.com/protocolbuffers/protobuf/commit/1cd12a573b8d629ae69f6123e24db5c71e92e18c.patch?full_index=1"
    sha256 "b1676b4c8a4a20dec9a7c0fe2c6e10ccf35673d6f3f6dce1ef303f37d0a0aa5b"
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
