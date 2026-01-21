class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.21.2/libheif-1.21.2.tar.gz"
  sha256 "75f530b7154bc93e7ecf846edfc0416bf5f490612de8c45983c36385aa742b42"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "74409afd4371c441de5349908173d75a5d04525c41a4f145cb6f669b1a98ed4f"
    sha256 cellar: :any,                 arm64_sequoia: "2158b5706d063ab6b40415990d257334f294159391184e07a6412db25ab7de05"
    sha256 cellar: :any,                 arm64_sonoma:  "580ffc4cf73852d0f1f7e96aa7deccea4685c1a00b6669707f01c96d3a8dcc80"
    sha256 cellar: :any,                 sonoma:        "3a6428ddc1440471e8b92203faff7a3047b6a52f7243ea7ce240982df5c7aee2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a6a3852712f9beba084f87ccc72f42300083525c7ee5a023f16f4ba0987755c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4b94da88750ba94317be8a3123ecafd7c635ca33e23c3381e28d57982a28baf"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "aom"
  depends_on "jpeg-turbo"
  depends_on "libde265"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "shared-mime-info"
  depends_on "webp"
  depends_on "x265"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DWITH_DAV1D=OFF
      -DWITH_GDK_PIXBUF=OFF
      -DWITH_RAV1E=OFF
      -DWITH_SvtEnc=OFF
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

  def post_install
    system Formula["shared-mime-info"].opt_bin/"update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
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
