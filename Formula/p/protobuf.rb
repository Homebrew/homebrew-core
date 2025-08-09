class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v31.1/protobuf-31.1.tar.gz"
  sha256 "12bfd76d27b9ac3d65c00966901609e020481b9474ef75c7ff4601ac06fa0b82"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "96f3a7755a630b2372e1dc18d10a803d56ac3c966ace84caac9af31110700429"
    sha256 cellar: :any,                 arm64_sonoma:  "7c87c79423ea24d2cbd9e6cd7162324137dd486d04e8aa9f8c73e3d355149cd8"
    sha256 cellar: :any,                 arm64_ventura: "bb6160063f2163636b416c2532a7ceba328ccca70bb979af95e8115786d540a7"
    sha256 cellar: :any,                 sonoma:        "47f034e4a05137134ae37688830815040b78bb0c26d468e866f0fe8bca2f46ce"
    sha256 cellar: :any,                 ventura:       "af5631783e4302a4d6b02078e62e0aee64ce3f0fa94ec3ee0ba624cf4d678d90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d79abad3aa4cfd7f187a72204c2dc93cc0d5438cff490220f40e73727b81fbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b759e411c49ff28ee2ec516519a9b254ed3762d45835d7479d0b520bc4d32ec6"
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
      -Dprotobuf_BUILD_TESTS=#{OS.mac? ? "ON" : "OFF"}
      -Dprotobuf_USE_EXTERNAL_GTEST=ON
      -Dprotobuf_ABSL_PROVIDER=package
      -Dprotobuf_JSONCPP_PROVIDER=package
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
