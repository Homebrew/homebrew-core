class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.21.1/libheif-1.21.1.tar.gz"
  sha256 "9799b4b1c19006f052bcf399c761cc147e279762683cefaf16871dbb9b4ea2a1"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a4d240ec0799018bbcd3e7ad4a991679009c68bb2911907f03ceda19322442c0"
    sha256 cellar: :any,                 arm64_sequoia: "e8f60419d76dc16a9522799939bbcca3d77e4b0c5c597d613c2b9477672c54e9"
    sha256 cellar: :any,                 arm64_sonoma:  "dfafea571ce5df582c917961edeacd444cc7fea4ebdd8859ec8f8e173770ea25"
    sha256 cellar: :any,                 sonoma:        "87356fb2135677dde6645cb48b17622bd39e4c167d0020b3dabd4cdec35b7a4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95e3276d78b921dbbb7447cbec393b05f7def07987f5167d0f3f15155da2d299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfc2b1a8c97150776342757fd53eaa12c1c46d1683ba2ddee4c26a08954b477e"
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
