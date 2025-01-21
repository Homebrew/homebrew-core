class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.19.5/libheif-1.19.5.tar.gz"
  sha256 "d3cf0a76076115a070f9bc87cf5259b333a1f05806500045338798486d0afbaf"
  license "LGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a5052734e22ea07d74011fe52ca8702df87b19319ba0da9ba97539ac4f95e91f"
    sha256 cellar: :any,                 arm64_sonoma:  "0a662ff4f01bc187dde030514f06c63d19f6d38d9f6da98e30cb37e2c05fab14"
    sha256 cellar: :any,                 arm64_ventura: "d6958d903f6a5c916f9964b2d9111000399ddefcc90f934cc75da7fda3ec3d45"
    sha256 cellar: :any,                 sonoma:        "93a936ad661d0d727be5f9c5c060b757ba2baac5961b8cc360f6cc4cf24cbfd7"
    sha256 cellar: :any,                 ventura:       "9d4afb170b02f4098207199a480a17cd7a74001e7ecd82515b514f2251fead9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edbac079f2fd763a2b656db04e1be6e765468be32ae1a02b83e237f327854054"
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
