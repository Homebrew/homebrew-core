class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v36.0/protobuf-36.0.tar.gz"
  sha256 "399931c793f4ac6db81045b00b06dd07c877b48aeecf36c797f65c541fb533e7"
  license "BSD-3-Clause"
  compatibility_version 5

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "b6d41daa3a6c3b85ca57e7bd4d8c59145a39b8acec5e1457934343161d019a22"
    sha256               arm64_sequoia: "2b349795081ff0fe0c6a850f01dc96766771380a9b3798c604ecdd18ddd92a96"
    sha256               arm64_sonoma:  "7eb27d1bf8e5791ed4dabd81b60fb15e3f91f910bd48597e60108daa00335b88"
    sha256 cellar: :any, sonoma:        "1fb99f40afcfee4da81a2f1c49c35606623b201a7968e16bc2b6360b1a5fd7b3"
    sha256               arm64_linux:   "67b7e8ffa74d2a15cebe883283f7c999f070ab8a0f91582c03101cdcdfc13315"
    sha256               x86_64_linux:  "61ee855d1c53fba1a3cb4c5f3ac53dd549daf8cf83ef5ed7d6ff565735e7fa48"
  end

  depends_on "cmake" => :build
  depends_on "abseil"

  on_macos do
    # TODO: Try restoring tests on Linux in a future release. Currently they
    # fail to build as Clang causes an ABI difference in Abseil that impacts
    # a testcase. Also GCC 13 failed to compile UPB tests in Protobuf 34.0
    depends_on "googletest" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :gcc do
    version "12"
    cause "fails handling ABSL_ATTRIBUTE_WARN_UNUSED"
  end

  deny_network_access!

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
