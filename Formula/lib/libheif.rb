class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.21.2/libheif-1.21.2.tar.gz"
  sha256 "75f530b7154bc93e7ecf846edfc0416bf5f490612de8c45983c36385aa742b42"
  license "LGPL-3.0-or-later"
  revision 2
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c5776c9ef53e403607ab2328afbb2920ab497f0a2dbfad203cfa8a8f40884be6"
    sha256 cellar: :any,                 arm64_sequoia: "fd60f7287586dcb7199162ffe1da8a31b6de6b74770a1b87b1c0e6aecbe31431"
    sha256 cellar: :any,                 arm64_sonoma:  "f07b3921374ef7da7e1bf8651770c9deaddce1e03e15b63c4cbe4de8f32d96c0"
    sha256 cellar: :any,                 sonoma:        "aa2c4ec8ec38823099177d13d6b5cd0447def0780d546cae5254a069fe8478b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba976751478b51a8c3d17b7ea58225946c99b6341e6fa58728f7aa23908d7eeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cd161945a39ca0dc334204125a078707d8fcddeb9cf71ab38bcf471b43a198f"
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
