class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v29.3/protobuf-29.3.tar.gz"
  sha256 "008a11cc56f9b96679b4c285fd05f46d317d685be3ab524b2a310be0fbad987e"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256                               arm64_sequoia: "8ac9ede06ec4f11b5b2c47b3f15a35cfb74043b716e4a91b4287b7345cdd80fb"
    sha256                               arm64_sonoma:  "2150b2720b5ae9bae3d1a7389b5ffb7085847eea5d0acf2757ebccb68289ca29"
    sha256                               arm64_ventura: "1db7cb15f9a82062cec8fb21d911eade129bb44067ea936db52ae42411a3e864"
    sha256 cellar: :any,                 sonoma:        "c02c1b1d259c09adfb869080dbbda7737d50fa6a3f0da77e431900f903cbea7a"
    sha256 cellar: :any,                 ventura:       "1d5a65d7d6155938c6de69878710c8058da2e57c61fcc4d45af0e189cebb7154"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03fc2bf06769c453368a8018168655efce163d57cda11671a5bd92306f864bdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d26e7e4f01c1f4259ddaacdaab92bb709623e2e4b0ba963400d26c367c24d4b3"
  end

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
