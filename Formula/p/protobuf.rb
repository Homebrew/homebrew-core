class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v27.0/protobuf-27.0.tar.gz"
  sha256 "da288bf1daa6c04d03a9051781caa52aceb9163586bff9aa6cfb12f69b9395aa"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "32ae9fbc2e154240c67abaa544af2a073b4e970d105e0dbb193c0ac1ee15df67"
    sha256 cellar: :any,                 arm64_ventura:  "9eeed6d82809dc0ad12256b2406599b2259657a8eb426f6fee78744b2d8a9a47"
    sha256 cellar: :any,                 arm64_monterey: "e10ee2e153fe6f5c2456bf37ea9830d99e319a7b5a82ab5a33ddf4396afd270f"
    sha256 cellar: :any,                 sonoma:         "c205eafb28b1bafcf457280d8f6054b135a7ea613695d911a4d89df35ae10e8e"
    sha256 cellar: :any,                 ventura:        "6ea0afb4c3d7bedc2163b202017e41069930282b27f35da9271a12116933f66b"
    sha256 cellar: :any,                 monterey:       "b2fea4174486476c09f593d74f69502940357ad148881c1cdf50e0ed19cad05c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35461a55cd16405929cf06aafc1daeb2b8771a5065a04980bc8dc8734dd2d01e"
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
