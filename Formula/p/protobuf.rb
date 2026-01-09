class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v33.3/protobuf-33.3.tar.gz"
  sha256 "79f8bb7ced6281dae7cd6931a0eebdff821cfec099d7d8033c9f4cbbc32f1b7a"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d455ee91bba7e47efb3089a0f9d4106c6e6363aac12418160507e07249bf3694"
    sha256 cellar: :any, arm64_sequoia: "344b419c348ed0bbdc91d68e2d8e039eb4d6c247137afad860518e9b325bf4d0"
    sha256 cellar: :any, arm64_sonoma:  "e194892d0ef67fb90ca480e00914c9da2021caa8449302c32b74f5473d2abc49"
    sha256 cellar: :any, sonoma:        "51fc730101b20c50a6e8f7b848cdcfdd5b4002481dc46b7531cfadde5da93a2e"
    sha256               arm64_linux:   "f7ec32aaac49071094c3a3d24f2a68b905aad3b527b062b7525f0bd7e9882dca"
    sha256               x86_64_linux:  "71a0654071ff29797dff8dd1c79999e8322a4709e3ad1dec554d67122803bf4a"
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
