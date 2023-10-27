class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://github.com/HappySeaFox/sail"
  url "https://github.com/HappySeaFox/sail/archive/refs/tags/v0.9.0-relca4.tar.gz"
  version "0.9.0"
  sha256 "bab59ed91805121c58963fb7a6f2cb6a402c88e52c5e282d2dc2f13710eb67ef"
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
    mkdir "build" do
      args = %W[
        -DCMAKE_INSTALL_RPATH=#{rpath}
        -DSAIL_BUILD_EXAMPLES=OFF
        -DSAIL_DISABLE_CODECS=svg
      ]
      system "cmake", "..", *std_cmake_args, *args
      system "cmake", "--build", "."
      system "cmake", "--install", "."
    end
  end

  test do
    system "#{bin}/sail", "--version"
  end
end
