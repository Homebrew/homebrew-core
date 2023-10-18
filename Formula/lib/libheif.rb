class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.17.0/libheif-1.17.0.tar.gz"
  sha256 "c86661e9ef9c43ad8de9d2b38b7b508df5322580b24d22fc25a977e7fdb26f3c"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3603cb66e439a18b93913948d80ec242817502d28c777e7ba99dcbe161430791"
    sha256 cellar: :any,                 arm64_ventura:  "0bb2044fda6c88ffe17cd503a4b0efbb3e8aad98f906ecd4f1ef6a02ffd443c3"
    sha256 cellar: :any,                 arm64_monterey: "bda82f1705b60091e00a2dc984ea7e0d2e5661aeeda7186dab22b1025d475dab"
    sha256 cellar: :any,                 sonoma:         "030fe4fc307f2f0db05caae3fca8fcc3eb3925cfc60035b8d5983430ec9d2ffe"
    sha256 cellar: :any,                 ventura:        "64b65254a14580ff7e0d61892f98892a0fb36aee22683d7b999e7ab2219ae4d1"
    sha256 cellar: :any,                 monterey:       "2f92b59f2c3441e59ec588cb3a1c779f94dac0db7466c228b9eb5f6ac31f118b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c39626d741b40c588cdb309d6f2b076a621dfc86edd768094fcc5ae79bac11ea"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "aom"
  depends_on "jpeg-turbo"
  depends_on "libde265"
  depends_on "libpng"
  depends_on "shared-mime-info"
  depends_on "x265"

  def install
    args = %W[
      -DWITH_RAV1E=OFF
      -DWITH_DAV1D=OFF
      -DWITH_SvtEnc=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples/example.heic"
    pkgshare.install "examples/example.avif"
    system "cmake", "-S", ".", "-B", "static", *args, *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "static"
    lib.install "static/libheif/libheif.a"
  end

  def post_install
    system Formula["shared-mime-info"].opt_bin/"update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
  end

  test do
    output = "File contains 2 images"
    example = pkgshare/"example.heic"
    exout = testpath/"exampleheic.jpg"

    assert_match output, shell_output("#{bin}/heif-convert #{example} #{exout}")
    assert_predicate testpath/"exampleheic-1.jpg", :exist?
    assert_predicate testpath/"exampleheic-2.jpg", :exist?

    output = "File contains 1 image"
    example = pkgshare/"example.avif"
    exout = testpath/"exampleavif.jpg"

    assert_match output, shell_output("#{bin}/heif-convert #{example} #{exout}")
    assert_predicate testpath/"exampleavif.jpg", :exist?
  end
end
