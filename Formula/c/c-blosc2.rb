class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "b4fbad51de56abf2f4660bd1cb9801bc044662db3ea009ede454b4fd36fd98eb"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8885772a6be45e1b5c422cbefe46383d796a41c9e0765b7b962a3c7d832da6ea"
    sha256 cellar: :any,                 arm64_sequoia: "c9b0aa19b401d37443ee64da32dc719305c633fd16ec70c8c67f4af486eed9d9"
    sha256 cellar: :any,                 arm64_sonoma:  "7cb7324c94f25b9c7f141364a5565763cee9a5a66d9d9ea5d543519ece6fef80"
    sha256 cellar: :any,                 sonoma:        "60b680b455f871578730f7df0a5e239107a0e721b199caa63d585a8ad96b4954"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "177bf0f050e7dcf8cd50a5d11a1f2d0c576029903d56b31365d9e424de3eb75a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13b116d3169151e5e363b6d6e01776b07136ab7fbd87af56df551635c4a0c106"
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
