class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v2.21.3.tar.gz"
  sha256 "4ac2e8b7413624662767b4348626f54ad621d6fbd315d0ba8be32a6ebaa21d41"
  license "BSD-3-Clause"
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0285d84023efb6e0407e5094bce81f03e2c2b73edf38e92b4aa2db279eb0b927"
    sha256 cellar: :any,                 arm64_sequoia: "8804b8809228eafa8d06c4b3acfe77b108fa63ce6f4df82a4ac03fd86016e454"
    sha256 cellar: :any,                 arm64_sonoma:  "c4061219864a47d710ac2d063cd7b25064949460bc7fdbdc46177626c2260a8c"
    sha256 cellar: :any,                 sonoma:        "0219fcdd5a1fe61c51d8604ed233283410edd60f2196a901a7a1dea2e29d5101"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d431a804e2c29bd36335d6d7b3f77b90b33228e8e02b6abaaeb136ea67b282d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70e777acc2ab3502e45149d7d429866a617627b1b309b5883c38467d3319fe40"
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
