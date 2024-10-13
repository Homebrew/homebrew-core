class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.18.2/libheif-1.18.2.tar.gz"
  sha256 "c4002a622bec9f519f29d84bfdc6024e33fd67953a5fb4dc2c2f11f67d5e45bf"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e8d16fb379fb5bcc42d9cafcb0bb4cf6907baf36cee1e7f274e5d63feea6c525"
    sha256 cellar: :any,                 arm64_sonoma:   "3ac03a6aa83b0c636c640cd953082d5e06f06d2fa74d7a50914812bf6bd73203"
    sha256 cellar: :any,                 arm64_ventura:  "392d7fd61637d1912c95ad3f1629dac3da032f49d01d966c9813d0f65e36d994"
    sha256 cellar: :any,                 arm64_monterey: "c43506ecb80ccd6f46951d459579e4af1ebeb4a91ae800681f26f28457b17ec4"
    sha256 cellar: :any,                 sonoma:         "8243388a035f0666bb9cbb1950b0c2cb3d0ffd06640e8eb8baae9f82b1f1e64e"
    sha256 cellar: :any,                 ventura:        "352eeaa2087cf976407e06b883825374c033299c339e507b8525fad82bef3613"
    sha256 cellar: :any,                 monterey:       "9aa1dbd3f239169fc2de33fdf18a2b4ffadcca81d9121264ccbb4054ce8374ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "054df00dc283e020bd17612943df5e0c5143fe3d89122d87c8c97cd14eb534fa"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

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
