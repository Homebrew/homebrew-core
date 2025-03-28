class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v29.3/protobuf-29.3.tar.gz"
  sha256 "008a11cc56f9b96679b4c285fd05f46d317d685be3ab524b2a310be0fbad987e"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "974f508de7802da742cfb636f66256b15ab8a59a800b5401b9ae39ab482a2127"
    sha256 cellar: :any,                 arm64_sonoma:  "45f33e4209cd2ff0d3ec4552dbbc129bebda7db475ad64ee62a476e633f62f4d"
    sha256 cellar: :any,                 arm64_ventura: "8753131a2e62a9db951e367d0a68285302873b1ea98f1de42b1e2873c1ea8d9a"
    sha256 cellar: :any,                 sonoma:        "1a3e4e68678b839bf130a3a78f5249efc2d37002c36aba45ab26dba2655dfd15"
    sha256 cellar: :any,                 ventura:       "db720629e1ab49f4ab7adc14e796c10b05a820a6c7cead816141a73a62252bee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcdcb24188a33cfe579bf07bf635ccfc4e3372cc03ee91749b42ea077d1dba62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63215a7811024353ef11418dc0210033ab677194c7b78defa105e69dadb648da"
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
