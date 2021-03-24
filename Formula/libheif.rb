class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.11.0/libheif-1.11.0.tar.gz"
  sha256 "c550938f56ff6dac83702251a143f87cb3a6c71a50d8723955290832d9960913"
  license "LGPL-3.0-only"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0cace1e7df98284e212181d14cc4537e59b67f296703516f4fedce8424647c2f"
    sha256 cellar: :any, big_sur:       "68c4c76e85e0e09d12c23ff09ed7016d7755db92f5cdc05896ffd04717bffc78"
    sha256 cellar: :any, catalina:      "2d817cd7e3d244cf7d076ac2978105d08694f067a158a3de4c53834583097509"
    sha256 cellar: :any, mojave:        "139518ff3ffb704d73d41560470ac11e025816310c1a800e64f2eaaeb2df9a47"
  end

  depends_on "pkg-config" => :build
  depends_on "aom"
  depends_on "jpeg"
  depends_on "libde265"
  depends_on "libpng"
  depends_on "shared-mime-info"
  depends_on "x265"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
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

    output = "File contains 1 images"
    example = pkgshare/"example.avif"
    exout = testpath/"exampleavif.jpg"

    assert_match output, shell_output("#{bin}/heif-convert #{example} #{exout}")
    assert_predicate testpath/"exampleavif.jpg", :exist?
  end
end
