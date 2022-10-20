class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.13.0/libheif-1.13.0.tar.gz"
  sha256 "c20ae01bace39e89298f6352f1ff4a54b415b33b9743902da798e8a1e51d7ca1"
  license "LGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "83604fff14ecaac7b0a5b51ccf6edb51005874787ffb68424aa6eecdd9c58214"
    sha256 cellar: :any,                 arm64_big_sur:  "e1da93c3b370ba6944466c092e2c9789387f581b048831957b480fcd1dce3196"
    sha256 cellar: :any,                 monterey:       "245040fbabce119b2d62d14252839abca053e4d554e7b35f56c1e12c9a7551e6"
    sha256 cellar: :any,                 big_sur:        "e50abe1e9e9ac7a1fe1a81fec71d5fa6fa4dfd595a7086c6ba6c0bab63ef1414"
    sha256 cellar: :any,                 catalina:       "9286b40ec5688cf50dbc8735f2c145aa54db29c04a03d935952cbeff87abdada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c286261b6b2d37f72847c9b4e64d97d358f7b783918e918e2a1d41b6f360865a"
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
