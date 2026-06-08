class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v35.0/protobuf-35.0.tar.gz"
  sha256 "8f907baca4b34a3b4854103ba5811e418fb6e2ff11fe0d8df9e8280b11d79926"
  license "BSD-3-Clause"
  compatibility_version 3

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "617e6318aac9524afc8f49763138d869ca3b1ad3455bc2b759e36615641a6ddf"
    sha256 cellar: :any, arm64_sequoia: "f2383446f2eb60ed37f4c7d5193ce4baad0f170b3cf7660456808da80d246e4c"
    sha256 cellar: :any, arm64_sonoma:  "f40f92474ad7fcdde1bbe8e3b6a60fbe0e15c47ff0c492b7ddc015f31880fbd7"
    sha256 cellar: :any, sonoma:        "5f23e95b8621046cce9f3dad81903e4ac0c638b476d712774d934f35683124d3"
    sha256               arm64_linux:   "78a5ca3a49f180bd859fb4e80168b3faed3b5acff398815f37175b22dbfa8a25"
    sha256               x86_64_linux:  "b995fb44ae245df9abca05b821761fdd7120236b5bd543cba806f1180a5b16fd"
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
