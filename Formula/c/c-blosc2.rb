class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v2.21.2.tar.gz"
  sha256 "0cd42f4750e7e79614123b8de4f4b5ca8a0754ccb4aaa9e1eed8d7ec81a6719c"
  license "BSD-3-Clause"
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b90b2adacdcf864eea4068990628321458a62f5e72811bb28400adec402a9228"
    sha256 cellar: :any,                 arm64_sequoia: "33fc68f81dbc787acc3ae64b023cd09d80242a9a7e458898ac4b86b1f94338cc"
    sha256 cellar: :any,                 arm64_sonoma:  "0a7f6aec228fcba1fae3b4d320291c10570b08523b20848c3a5ca678e2dcea47"
    sha256 cellar: :any,                 arm64_ventura: "b4d4e1049bb8e7c72178241d0f59ee95873c78263c3e3408ae4cfb3aa7216bee"
    sha256 cellar: :any,                 sonoma:        "72eaa24a2b1d90f8f4da082d2b3b93e4f66570c3e31cba9fefa6fd607eccf969"
    sha256 cellar: :any,                 ventura:       "4cbd25230efb0cf29998349d7aef3685244f7e4dd4cefe5c5f5ed54d2c1f17b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9adecf413925dacef2629759fb38ef2cb6deddcf9d37c3b791327a54ff1479c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2eb91ca0414d4dc468ed8a317d6a8ffe54e1ebd923102d9c2eb6958d23180ae6"
  end

  depends_on "cmake" => :build
  depends_on "lz4"
  depends_on "zstd"

  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1400

    internal_complibs = buildpath.glob("internal-complibs/{lz4,zlib,zstd}-*")
    odie "Failed to find vendored sources for removal!" if internal_complibs.count != 3
    rm_r internal_complibs

    args = %w[
      -DBUILD_TESTS=OFF
      -DBUILD_FUZZERS=OFF
      -DBUILD_BENCHMARKS=OFF
      -DBUILD_EXAMPLES=OFF
      -DPREFER_EXTERNAL_LZ4=ON
      -DPREFER_EXTERNAL_ZLIB=ON
      -DPREFER_EXTERNAL_ZSTD=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/simple.c"
  end

  test do
    system ENV.cc, pkgshare/"simple.c", "-I#{include}", "-L#{lib}", "-lblosc2", "-o", "test"
    assert_match "Successful roundtrip!", shell_output(testpath/"test")
  end
end
