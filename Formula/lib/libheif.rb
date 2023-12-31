class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.17.6/libheif-1.17.6.tar.gz"
  sha256 "8390baf4913eda0a183e132cec62b875fb2ef507ced5ddddc98dfd2f17780aee"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cf3a64f00db69ab4cfacf6cda66a2b9df7425e8797cc5756a1713b06af8c5c6d"
    sha256 cellar: :any,                 arm64_ventura:  "b39a1ccde3da6980cf5a2c39b26615a0f65be474b11c9db7549d74624089f328"
    sha256 cellar: :any,                 arm64_monterey: "f72576b3314c55b10a9c3920431b53079b4735fed5582f16dd7cc59177d5e684"
    sha256 cellar: :any,                 sonoma:         "dc7e4ab57ef422d3d5aa23373ba024e68ab1b9e65f452d9d59944c96eb350e0b"
    sha256 cellar: :any,                 ventura:        "ecadbc951af706b80845fa1d3605ca906402b9f0aa430bfa0310fb5cb953d9e1"
    sha256 cellar: :any,                 monterey:       "87088818abfeb2b856f149e692113bb724071defdb9e814f91d7507b1ba948dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "510ac3dd14575e3dce887e8d6452e1b7ed150db43ec6a1e3f47784766adcc7ff"
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
