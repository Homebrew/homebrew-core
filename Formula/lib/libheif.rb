class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.19.7/libheif-1.19.7.tar.gz"
  sha256 "161c042d2102665fcee3ded851c78a0eb5f2d4bfe39fba48ba6e588fd6e964f3"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0fc06cce535f6a1131182337ac5a50aa220f6a61b879db94002634483e1a5c3d"
    sha256 cellar: :any,                 arm64_sonoma:  "09a066bd6db3bf2816defde4d0e8523cc0c77a9725bf6bb82962b491a2e70163"
    sha256 cellar: :any,                 arm64_ventura: "bd4e27af3a4bcab55291ccb64b5837988ff053a9a4f9e3a5e855f099a3edf759"
    sha256 cellar: :any,                 sonoma:        "7b0171ccd79095f52a6c16bde48c370d7b5ac047f0c0265dc0aa3e7cd59519f0"
    sha256 cellar: :any,                 ventura:       "c093278679c0869f9f711c95e6b65b145d3e888de96608e1a5fe1f4734e3a2b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75ceb8a6629880dac1f9213373d61b57cc94c1a0f71a7d008ef44391b7ab5b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f95e3f3388b36bf3a81c226356158d7c045ba320d1d84a839c89e40d25a7d3eb"
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
