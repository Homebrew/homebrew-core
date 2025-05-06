class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.19.8/libheif-1.19.8.tar.gz"
  sha256 "6c4a5b08e6eae66d199977468859dea3b5e059081db8928f7c7c16e53836c906"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0771e767a82c4817c544678e4afa4c52c9003457684031d5458cc48faaf5b3e6"
    sha256 cellar: :any,                 arm64_sonoma:  "3fd45b31c2c6e1fc66e6b17745bd9d72626f292ee10cc934ff3dd605672ff567"
    sha256 cellar: :any,                 arm64_ventura: "8c09d6ca38fb9b6c25ded953c1d5b3f71afa66cb2c71313e5714ca82022f8a71"
    sha256 cellar: :any,                 sonoma:        "34f944065cf6900138ba98a3726a6608d7086fa5146bd9864a7b27f0d13b72ce"
    sha256 cellar: :any,                 ventura:       "bec7e48c76af4bb07c4b58898232a2f964829190bcfd12ca36028ab81b641508"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adfc024f5001a4f14c6d731044e524682e97d8a5c583aa779c46caec15794652"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ab65fcd74b045636c1797e2c7dece8d6a83ada31cce9d3b3adc9adf6cd7a152"
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
