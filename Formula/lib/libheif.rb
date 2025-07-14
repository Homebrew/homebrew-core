class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.20.1/libheif-1.20.1.tar.gz"
  sha256 "55cc76b77c533151fc78ba58ef5ad18562e84da403ed749c3ae017abaf1e2090"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "73da052e0d858e1b883c24994b18024e486d8082117506ee0a8cdfb19cdcf78c"
    sha256 cellar: :any,                 arm64_sonoma:  "870e6f8c87141c0f6b7a32ad03e3aab5056174cad74ba38219b834a1ccc6e889"
    sha256 cellar: :any,                 arm64_ventura: "fdccbaf73b7f31f1e80aad0eb1620b9bb4c593bd1ab15d38a292362025a4e308"
    sha256 cellar: :any,                 sonoma:        "6b9d20cb53c61344bc2a5b40b354a28f244c0af1135915e8c579569146bd80c1"
    sha256 cellar: :any,                 ventura:       "61ff240e16fe7bca5825aa9d203b5f0a7e4104767a9703ea5ef6f7d7a33040d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a77b4b824f14474be1f20b5ebf190d963bcfb502880920ff572152d25149111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00f47cf9e3b480b78dd2aa565c787920951c437ed6972056a681cbd3779bf6f3"
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
