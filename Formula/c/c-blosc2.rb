class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v2.13.2.tar.gz"
  sha256 "f2adcd9615f138d1bb16dc27feadab1bb1eab01d77e5e2323d14ad4ca8c3ca21"
  license "BSD-3-Clause"
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8db72646fc1755ee4fa84d1b5bda0d81258b6808159073b9b4dbe15ebbbd97f4"
    sha256 cellar: :any,                 arm64_ventura:  "81416ed7c32349649139b7de7daae2db24aa3351a2581a031af9645d61e181e9"
    sha256 cellar: :any,                 arm64_monterey: "6fb12f94c66c031d68eded33b35965abff3ef0c88efeac67374dd0e17ff959a3"
    sha256 cellar: :any,                 sonoma:         "c6c2fec12055d25412ade617ec5e904cd01ceb76865a765ba6eee64336d184c6"
    sha256 cellar: :any,                 ventura:        "45f494cf8b93f2c896ac135f6397ce168e5113b705292c4098d218d50e0bb1ba"
    sha256 cellar: :any,                 monterey:       "d4ad769882e8fdc0b02d1a0cb7bb7fb62e4802726b0cd97996a285444b7f7855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4e83e69f6f5ce989d0553a1615ca0afdf258330f0d456b0a8b4fb5cad798dc3"
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
