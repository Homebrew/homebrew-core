class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://github.com/HappySeaFox/sail"
  url "https://github.com/HappySeaFox/sail/archive/refs/tags/v0.9.0-relca4.tar.gz"
  version "0.9.0"
  sha256 "98daa426dec98d994b532a45bfaefb6d2c60dc6713e84fb00a51c2b94fbf6eab"
  license "MIT"

  depends_on "cmake" => :build

  depends_on "giflib"
  depends_on "jasper"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libavif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "resvg"
  depends_on "webp"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DBUILD_TESTING=ON
      -DSAIL_BUILD_EXAMPLES=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "ctest", "--test-dir", "build/tests", "--rerun-failed", "--output-on-failure"
  end

  test do
    system "#{bin}/sail", "--version"
  end
end
