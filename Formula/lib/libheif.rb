class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.17.6/libheif-1.17.6.tar.gz"
  sha256 "8390baf4913eda0a183e132cec62b875fb2ef507ced5ddddc98dfd2f17780aee"
  license "LGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d3e6043da49e8af564ff89e35885c1a66ed9c8e9c1f133ca89ed592261737b04"
    sha256 cellar: :any,                 arm64_ventura:  "a3f34efc3e3ac4b36e3950b6fdb0f89493ce815f7126aa4cc4f97b69e4ab9d0d"
    sha256 cellar: :any,                 arm64_monterey: "884eaad8e17d3b772e7bd7db7422e7cb896253b295815dc33c0b85fc2f3291ba"
    sha256 cellar: :any,                 sonoma:         "440c4bd0f9626ef2129e3589e5419f493f69cb82cd4c3fe2dd86790b099f8c0e"
    sha256 cellar: :any,                 ventura:        "fd1df7cacc463f08a5d43063189c93789409fb0cecce1c156d28c93edd4489ec"
    sha256 cellar: :any,                 monterey:       "09ecdec8c4360a73d3bfcec2d21e4068754ac2cc5b77be6c50133c1f31ff86ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30417c8829022c3b2114bce3f9fb89a346ec1217efcf29db813a1c1b20bc84ba"
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
