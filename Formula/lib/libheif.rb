class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.21.2/libheif-1.21.2.tar.gz"
  sha256 "75f530b7154bc93e7ecf846edfc0416bf5f490612de8c45983c36385aa742b42"
  license "LGPL-3.0-or-later"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2e879a02aadd09f9136d3c614e0eaa9800bfb12b82c3fc6105819fe7af8075a4"
    sha256 cellar: :any,                 arm64_sequoia: "1e21503c29c6a82193d520e05239a248e7d1ecb967edafe693dc42c45d1a906c"
    sha256 cellar: :any,                 arm64_sonoma:  "852801214a948486b04117d274ca86a9cec86d2eb4668163652c53b11c953dde"
    sha256 cellar: :any,                 sonoma:        "d42f0f04f44cd8e2d353c0515f2b2621838c36b621b02b4c78d52cf233b63fb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14f4d79e3c3fa91e342649efbf422a33c8fa22c4e0095074b859e861ae1d510f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c140f9b88d5a47a803272ec24ce007e4692a911889ac399fd88fd8ac1c853819"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "aom"
  depends_on "jpeg-turbo"
  depends_on "libde265"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "webp"
  depends_on "x265"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DPLUGIN_DIRECTORY=#{HOMEBREW_PREFIX}/lib/libheif
      -DPLUGIN_INSTALL_DIRECTORY=#{lib}/libheif
      -DWITH_DAV1D=OFF
      -DWITH_EXAMPLE_HEIF_VIEW=OFF
      -DWITH_GDK_PIXBUF=OFF
      -DWITH_OpenH264_DECODER=OFF
      -DWITH_RAV1E=OFF
      -DWITH_SvtEnc=OFF
      -DWITH_X264=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples/example.heic"
    pkgshare.install "examples/example.avif"

    system "cmake", "-S", ".", "-B", "static", *args, *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "static"
    lib.install "static/libheif/libheif.a"

    # Avoid rebuilding dependents that hard-code the prefix.
    inreplace lib/"pkgconfig/libheif.pc", prefix, opt_prefix
  end

  test do
    output = "File contains 2 images"
    example = pkgshare/"example.heic"
    exout = testpath/"exampleheic.jpg"

    assert_match output, shell_output("#{bin}/heif-convert #{example} #{exout}")
    assert_path_exists testpath/"exampleheic-1.jpg"
    assert_path_exists testpath/"exampleheic-2.jpg"

    output = "File contains 1 image"
    example = pkgshare/"example.avif"
    exout = testpath/"exampleavif.jpg"

    assert_match output, shell_output("#{bin}/heif-convert #{example} #{exout}")
    assert_path_exists testpath/"exampleavif.jpg"
  end
end
