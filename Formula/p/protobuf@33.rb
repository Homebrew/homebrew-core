class ProtobufAT33 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v33.6/protobuf-33.6.tar.gz"
  sha256 "16498d7dc7967e9b100632138babd4b86b61592beeccdd556f67539d9c231355"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(33(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "2d64f84300b7821b7037d5d2d04cb2d03beb2bfafadd9a053547c3d1161f664f"
    sha256               arm64_sequoia: "3fe2e1c32a10b77f9feb9c558d5e6e0269ec3c9895665b38b392af58e3bd32e3"
    sha256               arm64_sonoma:  "1fddb3b34488bc4a4dc9a3f605d4073f83eeb895c691a4c5bf7d847340894361"
    sha256 cellar: :any, sonoma:        "2b704a0acab895ebbcf8abe9393964bd987b5013ad3b533cd542273dc1394ace"
    sha256               arm64_linux:   "ff49075ad9620ce0fac8074ce86067449b31c20098655160138222acf5adacd2"
    sha256               x86_64_linux:  "e375d8fd9b6575b91bbbd59c06001df885c11a622540842fea3e8a9bec653d26"
  end

  keg_only :versioned_formula

  # Support for protoc 33.x (protobuf C++ 6.33.x) will end on 2027-03-31
  # Ref: https://protobuf.dev/support/version-support/#cpp
  deprecate! date: "2027-03-31", because: :versioned_formula
  disable! date: "2028-03-31", because: :versioned_formula

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "abseil"

  on_linux do
    depends_on "zlib-ng-compat"
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
