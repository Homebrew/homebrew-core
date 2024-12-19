class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v29.2/protobuf-29.2.tar.gz"
  sha256 "63150aba23f7a90fd7d87bdf514e459dd5fe7023fdde01b56ac53335df64d4bd"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f195f72fabe5f1daa8351ff6aab65a8c804a3dbb92fcfaf8d1232b4ebf25a66a"
    sha256 cellar: :any,                 arm64_sonoma:  "5e9a5397b8ab7cd8ac4e7481c1af5d64241df86f4205bc477fb8d366e004da5e"
    sha256 cellar: :any,                 arm64_ventura: "4d68c9a70abedef5e23774faa6a421588067794c02bd3892e0b57a9338c899b9"
    sha256 cellar: :any,                 sonoma:        "cf40b8edaaf2df31d1724f470604faad18345b2c74515b970b755fc0f186697a"
    sha256 cellar: :any,                 ventura:       "82758d30260da4dbc686ec09e14dc747f45559119ee5a29e9e69a95db3584bb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b1b7c978bdf5e8f0b50089df1d1b24e5f2448e6aeb59250c6b38dcef351e97f"
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
