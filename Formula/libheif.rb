class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.16.2/libheif-1.16.2.tar.gz"
  sha256 "7f97e4205c0bd9f9b8560536c8bd2e841d1c9a6d610401eb3eb87ed9cdfe78ea"
  license "LGPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "d6a9f8735ff0ae320c38d8882700cc31c68fbda4a9d54f769e0ae8bff0600f7e"
    sha256 cellar: :any,                 arm64_monterey: "8a77980947f74d9abdbe2f78a41d078e6a46009646c820c7cf74472fcaed0d27"
    sha256 cellar: :any,                 arm64_big_sur:  "1206b2a41a5fce3f9f2732f459dace3dc0d36fd4a637b3a83652944ba1c16d4e"
    sha256 cellar: :any,                 ventura:        "faa82db305858a35f05f8a49b13d57139fe816712639d3934f0ebee63552ae11"
    sha256 cellar: :any,                 monterey:       "35e069651a989c37686dd7bc3f907d2bfb580e68407b0736068e577fd91dabf1"
    sha256 cellar: :any,                 big_sur:        "29c122901654eb74af43a8e349a0b544c35ab0b1a4b732666fbe3c51bd5627a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a778a51a1112c3c8d82622f7d4079a500308b2df3119d81e4a4b60f13d2105e1"
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
