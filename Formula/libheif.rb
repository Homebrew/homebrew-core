class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.11.0/libheif-1.11.0.tar.gz"
  sha256 "c550938f56ff6dac83702251a143f87cb3a6c71a50d8723955290832d9960913"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6d4a4ac2d0947af84d7987c706fb6598bd87296b3c170bb9eb50270d2f2b3bed"
    sha256 cellar: :any, big_sur:       "daa9f993f1a04242f7786f141544fbb24a2c2d02e11f0253b6d72b6a8d6d3fe1"
    sha256 cellar: :any, catalina:      "0b269433daa8aca16395d3ddc75fc8b63e15750c7c8a3af4a3769af09081f326"
    sha256 cellar: :any, mojave:        "3ae3d4575f77c80b65ba04db875293422530d98ec80a61a6076316958fab6688"
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
