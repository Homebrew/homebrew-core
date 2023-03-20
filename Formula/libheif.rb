class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.15.1/libheif-1.15.1.tar.gz"
  sha256 "28d5a376fe7954d2d03453f983aaa0b7486f475c27c7806bda31df9102325556"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "649a164eb04ae67c7ee680f2db12056e0e0c79d9510e5940b346c54e9eeb88e9"
    sha256 cellar: :any,                 arm64_monterey: "ff51b4c0e99a60307cb26ffa05c24b1e3ef67829969a19dc85f95e881dc099a8"
    sha256 cellar: :any,                 arm64_big_sur:  "305cd39610e2a05c760448ef722afac2b9bc230f3248012296a279c6dbb93aa2"
    sha256 cellar: :any,                 ventura:        "5afe174adae78f29caf8bfd4427fbb41e3fbf82af8ff44098dc3a9371aa8c37a"
    sha256 cellar: :any,                 monterey:       "cc76c8be3470e8253c85cfe1204f94391e2599f0ff9c302d3aded4bc83c42da1"
    sha256 cellar: :any,                 big_sur:        "fbdfe6c282585a3f8f14575130ad24baa9220ebfe4464a116201fb0c5b3baa9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87421411f1ee23d5a017c4fb201263df8baaa488de71395c40e91db4c4214767"
  end

  depends_on "pkg-config" => :build
  depends_on "aom"
  depends_on "jpeg-turbo"
  depends_on "libde265"
  depends_on "libpng"
  depends_on "shared-mime-info"
  depends_on "x265"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
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
