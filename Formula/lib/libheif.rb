class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.23.1/libheif-1.23.1.tar.gz"
  sha256 "0de0327f60fcd47de90d5654c6fe152232738d60d84fe084ec3e0f35e03b166a"
  license "LGPL-3.0-or-later"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6e3678abf78f5df20b1142b2589dcbcdc6818df9875eacab04136d9268cf8148"
    sha256 cellar: :any, arm64_sequoia: "f57326a40cf29ddf8bce3983182e95bf1797092e2e1acc442ff7decac725af04"
    sha256 cellar: :any, arm64_sonoma:  "daba278885128a0faa1b936df985d5bda59f343fac099f0d6da0991e48d2f350"
    sha256 cellar: :any, sonoma:        "31bac0d92edaa5b8bfbfe9c2e5d28c50630eef62870096244398580cebdd9d48"
    sha256 cellar: :any, arm64_linux:   "0c086f70e27e8958f9e477aac008bbc9070066b1333383af1d909c025e1053a8"
    sha256 cellar: :any, x86_64_linux:  "1fd1b86db5c07d78114a7d27961a931b31a57785eebbb54fb90b959293a8ae2c"
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

  def caveats
    "Additional codecs can be enabled by `brew install libheif-plugins`"
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
