class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.15.1/libheif-1.15.1.tar.gz"
  sha256 "28d5a376fe7954d2d03453f983aaa0b7486f475c27c7806bda31df9102325556"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "af70b6bf74488aa57f19f1774c3b0ddd6f576e8c9f3c8a328482d88ef1d9c199"
    sha256 cellar: :any,                 arm64_monterey: "4f6d1be9ead93c33743bc1b1b8430c8feaf44ff6af6a79115321f343cf9055a2"
    sha256 cellar: :any,                 arm64_big_sur:  "4b8987c4c8d203ae3e715a58622188eaeb291b7d8a4ffa56db339c81a4acdd3c"
    sha256 cellar: :any,                 ventura:        "38578cb6f08eb56f887d9ec72fb1a3acdc519b1b8495225bba274bf8e5af5ced"
    sha256 cellar: :any,                 monterey:       "8aee905ee0896d3f2abdcef30319d3f60ce3df84e967f25145bcbabbc07fd17a"
    sha256 cellar: :any,                 big_sur:        "59a2a2cd71247e235d9ae8c9f2e40980586aafcf51762978228a5ac76c7daeba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82b90374e032ae9eeced09ed0f37c02b077f2c35f729a344c260f885a00cfca1"
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
