class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.19.5/libheif-1.19.5.tar.gz"
  sha256 "d3cf0a76076115a070f9bc87cf5259b333a1f05806500045338798486d0afbaf"
  license "LGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7362cb33a980ff16d59f44253146dffad69e4a82c860f07314b0ecad6a8d0487"
    sha256 cellar: :any,                 arm64_sonoma:  "d559071bd87df4e179136b4d1d7c5dd1e953137e84b7616a77ca66eb17649682"
    sha256 cellar: :any,                 arm64_ventura: "a962ade1a6eb63d7924ae754755d48b67da587ae5ad72646b3f6c9c093f51fd6"
    sha256 cellar: :any,                 sonoma:        "cf80a1839e76ef28e6a63ccce2a368822b91f66785e9070a49b6431f4ec274e8"
    sha256 cellar: :any,                 ventura:       "84242885c4fe3851ca56875ee8b6489a4f61dac8ada35836ee01ba00d2299319"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a8fa3d2bfd42c47eb692f331304d76eee4b9f5d0afed44a3a6bc1ccd5aedf96"
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
