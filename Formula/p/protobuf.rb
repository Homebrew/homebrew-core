class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v26.1/protobuf-26.1.tar.gz"
  sha256 "4fc5ff1b2c339fb86cd3a25f0b5311478ab081e65ad258c6789359cd84d421f8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9bbacbfb7f31456778fcfa37bccee409afabb49702843870270404fc18941022"
    sha256 cellar: :any,                 arm64_ventura:  "0ed7c159a485bfc56024239ddaec502bd5c7f9e36526b577d3fa9336c4009512"
    sha256 cellar: :any,                 arm64_monterey: "a84f278a50c61da15d24c789ac2bb45eb919adc02dc311a4f4c04c23e6f78d9b"
    sha256 cellar: :any,                 sonoma:         "99e10c650a00b3b017dd77642fd9230e97c472d40c71e6f34075f17dd0b94f90"
    sha256 cellar: :any,                 ventura:        "a9dd7c9469573cb267c78423e600bbcba67b172ed9abcf789f6a7cec42c2491c"
    sha256 cellar: :any,                 monterey:       "925c86112c0b15d006c5dea497b262f2d7960ecdb63b6d0b5aebbb28ed783be3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7460997e933897b54945444f56b3926407763cf2cdcc0d06b044f31eee252afa"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "jsoncpp"

  uses_from_macos "zlib"

  def install
    # Keep `CMAKE_CXX_STANDARD` in sync with the same variable in `abseil.rb`.
    abseil_cxx_standard = 17
    cmake_args = %w[
      -DBUILD_SHARED_LIBS=ON
      -Dprotobuf_BUILD_LIBPROTOC=ON
      -Dprotobuf_BUILD_SHARED_LIBS=ON
      -Dprotobuf_INSTALL_EXAMPLES=ON
      -Dprotobuf_BUILD_TESTS=OFF
      -Dprotobuf_ABSL_PROVIDER=package
      -Dprotobuf_JSONCPP_PROVIDER=package
    ]
    cmake_args << "-DCMAKE_CXX_STANDARD=#{abseil_cxx_standard}"

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
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
