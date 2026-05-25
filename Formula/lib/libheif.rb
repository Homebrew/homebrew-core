class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.22.1/libheif-1.22.1.tar.gz"
  sha256 "379b6abde094ba8f93620b91c230af2d7102945ad641231876074f3b113865fa"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1f3e43af36614e0ac6fd9415e29b6eb142d0e32a1defafd0214a90527b7eb1dd"
    sha256 cellar: :any,                 arm64_sequoia: "b33e8f022966a1a1f8c26b78ff83c725868313a4245180f75fc1618bfeba07ab"
    sha256 cellar: :any,                 arm64_sonoma:  "dbdc427e50935cc75110a4f4d993f4313f9517655d9a464f6a59b7702cbfd18d"
    sha256 cellar: :any,                 sonoma:        "e84d7d1f6c6c8b92ee45308ffc07f8f89a454a40b0a3db10f35f6103f8061507"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38eca108f6b72bb0112a5740c9d683b258726f6c9bb8b7daee6df68da58f25a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e88f68728cf651f75a143fdbf4e38abd3b211bcaa907d6efad67a2a51117a740"
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
