class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v34.1/protobuf-34.1.tar.gz"
  sha256 "e4e6ff10760cf747a2decd1867741f561b216bd60cc4038c87564713a6da1848"
  license "BSD-3-Clause"
  compatibility_version 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "052999e2596cd873392cfc3e9b351892d5dc839776dfb8a115eddf638c6baf04"
    sha256 cellar: :any, arm64_sequoia: "a6779ffa7ee2bc25076bc0338b558387ac18136d455ee822a6123c4bb76b8d3b"
    sha256 cellar: :any, arm64_sonoma:  "ba01f35bd0814496dc1d8b92aa519984da76decd084ef7dcfa145f6e952fa5e9"
    sha256 cellar: :any, sonoma:        "06892ef0f54c26fbbca4a01e8620079b1b83bcce53a82ffe04f19290f7df35a2"
    sha256               arm64_linux:   "ed890928c4ce477d2ea2ac38e44a253d161882ac2545eab91b974fde89592336"
    sha256               x86_64_linux:  "c439d6602fb48906ddd0f1adc80a49b51f71c23b03815de740fdf8b7e13934d4"
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
