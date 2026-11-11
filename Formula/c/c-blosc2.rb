class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "753a911cd0694fb075e6be830918af5f3fb0a90d47e61d0e1f03a051c5f113e5"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f2d62c69039f14121ec3d19ea99425f24e3d802566f8ef7213a75d205116ff01"
    sha256 cellar: :any, arm64_tahoe:       "ea919dd4dee0a4262fd7fd9fb91339079dafd18caea5358fe4ef0b08b75922b0"
    sha256 cellar: :any, arm64_sequoia:     "584ba9470d8f962d23d7c413f4d3075b08288f92781acdbcdbc24b673a8a3659"
    sha256 cellar: :any, arm64_linux:       "1f59c59a106570af1dc5c34374c9babbfa0c1cd60bc902e13eab3c4662d2c182"
    sha256 cellar: :any, x86_64_linux:      "4f1733874f0ee1505899a25ba8eaa858a5587da82ac0e22374c48fe00f0602d3"
  end

  depends_on "cmake" => :build
  depends_on "lz4"
  depends_on "zstd"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1400
  end

  deny_network_access!

  def install
    args = %w[
      -DBUILD_TESTS=OFF
      -DBUILD_FUZZERS=OFF
      -DBUILD_BENCHMARKS=OFF
      -DBUILD_EXAMPLES=OFF
      -DBUILD_PLUGINS=OFF
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
