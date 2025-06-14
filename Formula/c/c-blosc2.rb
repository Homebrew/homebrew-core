class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "9fce013de33a3f325937b6c29fd64342c1e71de38df6bb9eda09519583d8aabe"
  license "BSD-3-Clause"
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "06858fc531a6fa083376c0c4fdc251af286b32225615e786d245c3663ea5e9f7"
    sha256 cellar: :any,                 arm64_sonoma:  "2b58e26620bb98d4ad4f0f6de78279a7ab57a944db71067979263f530a20c14c"
    sha256 cellar: :any,                 arm64_ventura: "7ba4828bf194b49498e7804f6b8f92db2e9f8fd902a47ab0f0b5ed9f55a85e99"
    sha256 cellar: :any,                 sonoma:        "b988b12dd846c3b589acd2e5c49953dced17923410cb37b0e7d74f3d9cbb497f"
    sha256 cellar: :any,                 ventura:       "f835ba5fa5ae34caa23080247e780373246606d039890675a565fd5c645b5eea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c23e8e9b83acfb0e7e85934354a709b124040915c6dec3fc7fdd81c376d48477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "187f6b60f7242355a1f04a3a4638687de809b1ceada5631391887a37e6c0f93b"
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

    args = %w[
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
