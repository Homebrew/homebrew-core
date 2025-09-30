class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.20.2/libheif-1.20.2.tar.gz"
  sha256 "68ac9084243004e0ef3633f184eeae85d615fe7e4444373a0a21cebccae9d12a"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "299665cc7243e7382b0cf61392a846ade50eb2ff4ab5710e5212562a468cf918"
    sha256 cellar: :any,                 arm64_sequoia: "f3269404f33c86607273d0d84744067500483cba20ace6c1274b3ef8c09cfab4"
    sha256 cellar: :any,                 arm64_sonoma:  "e80e07cb6785637373ef0037b825ecf35b2e2e3cd78a8e73fea329d15eee5a3c"
    sha256 cellar: :any,                 arm64_ventura: "0d37be85f1da630c1dd0069c003b1bdff3e0796592ac88e7f9927b22ee08a0ff"
    sha256 cellar: :any,                 sonoma:        "ab9e7d6176e786ab51695fd2b9194261e15fcd040c0a1827fd2dd0bf1e491810"
    sha256 cellar: :any,                 ventura:       "d130bffc9ecb61cb142ee99fe36936f1786f356e5496fc9a9b1f40363937dd52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d9de659e7bebc56b68b7bde30f6f7c754aab8a381d396a24421bf1cf6d3e031"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55d51d8cfeb3c116e8fafc2d43f81de1cb9bf18d627fe0c379b4a94907876e11"
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
