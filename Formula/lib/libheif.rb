class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.16.2/libheif-1.16.2.tar.gz"
  sha256 "7f97e4205c0bd9f9b8560536c8bd2e841d1c9a6d610401eb3eb87ed9cdfe78ea"
  license "LGPL-3.0-only"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "82f6e15c2c6bbd6aabc793a219b24ce16695113c7df6d5a8cf1b4ac82a42034f"
    sha256 cellar: :any,                 arm64_monterey: "ee412a79e8f261e90bbc5fae5f2d6dd2f1e3ea615b5af2642146ac28121ac4df"
    sha256 cellar: :any,                 arm64_big_sur:  "ebc16ed45c1641dd955a5abe4065239d813e75d7cc75c119e94766077c469e77"
    sha256 cellar: :any,                 ventura:        "a8d94c2ee75e69789bf32a7c14f05812b08caa220d71640e0dab464be419387a"
    sha256 cellar: :any,                 monterey:       "eefc53996197989013739ad8c2d7fd77de54abaf3817ff8da4c5b1fcadaf37fe"
    sha256 cellar: :any,                 big_sur:        "ad7f86d5a3424f3b52985b36f7e1eb3fcc843bb4c9ebf97b2dc2107ba0880046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0afc0a90a360bd89f0cc382767c5efe724f7e8487b0212f60ab309f4ed42c1fc"
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
