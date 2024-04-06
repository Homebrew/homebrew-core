class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v2.14.2.tar.gz"
  sha256 "a45f927f6d0358d7ace24d75ef0b64df8e7d65ef2394f94d6591332fbea001b2"
  license "BSD-3-Clause"
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4db8b01f8bb7718ba5b7f831105537e81730654204ad21802c39c971569d8d0c"
    sha256 cellar: :any,                 arm64_ventura:  "fa639488f2c42fe83acfb2f5ccdf033b46dd4ef22537c689c10d2d95085f7dc9"
    sha256 cellar: :any,                 arm64_monterey: "b952e61d283ff32fc7fe884947aa21a7ce7fa9fc40a051082f774aadb5a6f0ca"
    sha256 cellar: :any,                 sonoma:         "5650a1e262ea784c11c7f8a3a5ac4a77847cdc53d8a1ade46e1319fddcee5fc3"
    sha256 cellar: :any,                 ventura:        "39d54039c6838912798c856881aabd60e20fbd4540f9461a6e8114cdbb9dfaa6"
    sha256 cellar: :any,                 monterey:       "6a218484fb9c03f3e1f976250740ece35bd7c7f51a72b5d8fbaa0b33fd46238d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e26c80e58a76239702ed59357fdfb3bbe06ef2ef4a3f6ec56623c473f7d709aa"
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
