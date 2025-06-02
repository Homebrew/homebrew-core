class ProtobufAT29 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v29.4/protobuf-29.4.tar.gz"
  sha256 "6bd9dcc91b17ef25c26adf86db71c67ec02431dc92e9589eaf82e22889230496"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(29(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "201dfed6c12d9a7eb607c3f42c880633f92ef4c0ac74f09d87c8698104b0d6fe"
    sha256                               arm64_sonoma:  "44a4fec5d0f3979f8ed747fcbf4d957f0b71ce5cfb95dc0dfa45f29ecc289ee8"
    sha256                               arm64_ventura: "2a4d3e77575a4867e8374dea35c266096cac7178bdea9f3a097d47d308b0fa31"
    sha256 cellar: :any,                 sonoma:        "eb0a700c134c204d4c933894671fc3d77933997d75403455b0b15ff4273932f3"
    sha256 cellar: :any,                 ventura:       "e6d5d1bb932672dab79550da9bd7794054d6c071771afec9b983959703e5559e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54d6518d1895616b61f84a09080472e3f92616b597e83e9a7fccb89f924a6202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c4e211562fcd5b1ed97bee9dff771e5b03b667d15f7c8ce066d6659c28a854d"
  end

  keg_only :versioned_formula

  # Support for protoc 29.x (protobuf C++ 5.29.x) will end on 2026-03-31
  # Ref: https://protobuf.dev/support/version-support/#cpp
  deprecate! date: "2026-03-31", because: :versioned_formula

  depends_on "cmake" => :build
  depends_on "abseil"
  uses_from_macos "zlib"

  on_macos do
    # We currently only run tests on macOS.
    # Running them on Linux requires rebuilding googletest with `-fPIC`.
    depends_on "googletest" => :build
  end

  # Backport to expose java-related symbols
  patch do
    url "https://github.com/protocolbuffers/protobuf/commit/9dc5aaa1e99f16065e25be4b9aab0a19bfb65ea2.patch?full_index=1"
    sha256 "edc1befbc3d7f7eded6b7516b3b21e1aa339aee70e17c96ab337f22e60e154d7"
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
      -Dprotobuf_BUILD_TESTS=#{OS.mac? ? "ON" : "OFF"}
      -Dprotobuf_USE_EXTERNAL_GTEST=ON
      -Dprotobuf_ABSL_PROVIDER=package
      -Dprotobuf_JSONCPP_PROVIDER=package
    ]

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build", "--verbose" if OS.mac?
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
