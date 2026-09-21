class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v36.2/protobuf-36.2.tar.gz"
  sha256 "3d9642a662d10e68ebae5e53f14dcce5105684212d5078f8e0d47d1ab3ae6b64"
  license "BSD-3-Clause"
  compatibility_version 7

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "35068a9351547528d7ce95e8d4c510e32650813ce585f0441070d1bc54de60c5"
    sha256 cellar: :any, arm64_tahoe:       "573d5907842eba3930afbac15f7fbab91df421acc610d9c79278062c1c70c33c"
    sha256 cellar: :any, arm64_sequoia:     "153d9b9b322fc8c54fe66dbaf2c8fe382294ee6a8fba35fd4c090dd61de3d77a"
    sha256               arm64_linux:       "ea1f621076b35e1caea7dc4c0eb9a70141148018fffa9e10b00ccf530e3b6fb2"
    sha256               x86_64_linux:      "88021d182eaa0c7a6fd41df1772748b22835f985aa34a9c5c308f5ac09e9ac27"
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
