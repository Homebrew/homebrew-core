class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "6aeb448ac490dee2a82fafab97382b62622a32a0e17a2d78d085ae8507f6ddd8"
  license "BSD-3-Clause"
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "65ebebb1fe4bd5922516d38ac8b704be1859b4985d4daff16b15439883d7f86a"
    sha256 cellar: :any,                 arm64_sonoma:  "6057d929ade251025504b13c309f9047971d003168d8882c0f9607789dccb8b3"
    sha256 cellar: :any,                 arm64_ventura: "7bf2b8771eae2a7f155ba889823cb6c706ab9b298ac3dfc866586cfe177c0f4d"
    sha256 cellar: :any,                 sonoma:        "c4f3bb8c2cb401adeab6fbb74c4389f9082baa301dc8d6ae0f812070c6e3456e"
    sha256 cellar: :any,                 ventura:       "e40342b849909e7e825c984423d8161be8fef3a5473f341860c57f1265b25844"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdaeb6519237799cb71e220766066d2dc378fef187fbef1c3a7d9c0fb5b9fb21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a786f86b740ef4cd6ba7a82534aeb3113acd375aab74772305ae8c8eb0693930"
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
