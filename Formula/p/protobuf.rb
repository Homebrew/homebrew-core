class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v34.0/protobuf-34.0.tar.gz"
  sha256 "e540aae70d3b4f758846588768c9e39090fab880bc3233a1f42a8ab8d3781efd"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5cc4e2b9f7717730d50bbfd6afb733b100b9982035a299f2b0967c330b9ab72a"
    sha256 cellar: :any, arm64_sequoia: "8e178b16a3794c2b2058186ab2ea289f9bffb31a89e480d0928324effc95e116"
    sha256 cellar: :any, arm64_sonoma:  "41e8ee14f2f1223a0a3b08730949142cec56356aa9430cd67a839c753f2c5281"
    sha256 cellar: :any, sonoma:        "3ff6c9e7b524e6a09d4647fc4618f4075f3b45c9b93f01a49506fc299808d6e5"
    sha256               arm64_linux:   "d85c8e5c591f6232f552633622e6a0237672627e25db0b676a7f3d4f6923dff6"
    sha256               x86_64_linux:  "e1c26a0c9ec43bfafa7a6a4212cc24ed9cf5c8128e88e4808394ee432001e84b"
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
    depends_on "llvm" => :build if DevelopmentTools.gcc_version < 13
    depends_on "zlib-ng-compat"
  end

  fails_with :gcc do
    version "12"
    cause "fails handling ABSL_ATTRIBUTE_WARN_UNUSED"
  end

  def install
    # TODO: Remove after moving CI to Ubuntu 24.04. Cannot use newer GCC as it
    # will increase minimum GLIBCXX in bottle resulting in a runtime dependency.
    ENV.llvm_clang if OS.linux? && deps.map(&:name).any?("llvm")

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
