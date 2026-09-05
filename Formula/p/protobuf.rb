class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v36.1/protobuf-36.1.tar.gz"
  sha256 "dc74fa582f559cbd31614ddfefb4868f43c919d7184bde514bb47f90c6025eb8"
  license "BSD-3-Clause"
  compatibility_version 6

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f499a54927c7d0e3c69802e6b87170830706acad787d7d872397ef53ead039aa"
    sha256 cellar: :any, arm64_sequoia: "d71337d9482a824ad67165dd3415364cc0253eba1dd1beed6e02b85f16d7b604"
    sha256 cellar: :any, arm64_sonoma:  "920c7978292fc0be14d1bd07a24d14e8ee6139b5839201a2c69e894e409e2b20"
    sha256               arm64_linux:   "115021ff733ba8a97bb36ba549606feed7ea2620e10b9c7b7a6cbcd780932b2a"
    sha256               x86_64_linux:  "c27a6deb435c3e498561a296973c1d7bb77bc2e3afb2b2f451b6c05509da25e5"
  end

  depends_on "cmake" => :build
  depends_on "abseil"

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
      -Dprotobuf_BUILD_TESTS=OFF
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
