class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v27.2/protobuf-27.2.tar.gz"
  sha256 "e4ff2aeb767da6f4f52485c2e72468960ddfe5262483879ef6ad552e52757a77"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "09e3b895f13d83aee27211a9fcb2258c637960bf143ee34082b6ff291a147e06"
    sha256 cellar: :any,                 arm64_ventura:  "cd5f9910f39ae8acc2bc57cf72601e9934156d538dc554f0d6bd63cb4ba7aed0"
    sha256 cellar: :any,                 arm64_monterey: "4e0ad3edeb7438ec98e3a6769f875184058bbdfc559269ba52c33506514b7d1d"
    sha256 cellar: :any,                 sonoma:         "8290acb228f9ec0d188af19b517550e663ebda375fc1db711ae53ea88a5a5683"
    sha256 cellar: :any,                 ventura:        "d00dec9425b9806aba49ba29b4a2d83a51ea4e00b4378fd0a224f15787fda7a4"
    sha256 cellar: :any,                 monterey:       "0b07cffc9b3f26b3aecad8b57088437c90c7a3623f75820f040e0c334d14ee2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09c8d9271d6fc39f29f2f2d8f2e9bdb19318804b14bff235853e5582b08537af"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  uses_from_macos "zlib"

  on_macos do
    # We currently only run tests on macOS.
    # Running them on Linux requires rebuilding googletest with `-fPIC`.
    depends_on "googletest" => :build
  end

  def install
    # Keep `CMAKE_CXX_STANDARD` in sync with the same variable in `abseil.rb`.
    abseil_cxx_standard = 17
    cmake_args = %W[
      -DBUILD_SHARED_LIBS=ON
      -Dprotobuf_BUILD_LIBPROTOC=ON
      -Dprotobuf_BUILD_SHARED_LIBS=ON
      -Dprotobuf_INSTALL_EXAMPLES=ON
      -Dprotobuf_BUILD_TESTS=#{OS.mac? ? "ON" : "OFF"}
      -Dprotobuf_USE_EXTERNAL_GTEST=ON
      -Dprotobuf_ABSL_PROVIDER=package
      -Dprotobuf_JSONCPP_PROVIDER=package
    ]
    cmake_args << "-DCMAKE_CXX_STANDARD=#{abseil_cxx_standard}"

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build", "--verbose" if OS.mac?
    system "cmake", "--install", "build"

    (share/"vim/vimfiles/syntax").install "editors/proto.vim"
    elisp.install "editors/protobuf-mode.el"
  end

  test do
    testdata = <<~EOS
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    EOS
    (testpath/"test.proto").write testdata
    system bin/"protoc", "test.proto", "--cpp_out=."
  end
end
