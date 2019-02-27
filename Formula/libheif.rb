class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.4.0/libheif-1.4.0.tar.gz"
  sha256 "977a9831f1d61b5005566945c7e16e31de35a57a8dd6eb715ae0f40a3595cb60"

  bottle do
    cellar :any
    sha256 "7d99d0d985f071d9ea06157fec47ef88c1122b4869e493c9cb686c6d3d15a61b" => :mojave
    sha256 "aea91efc960b71da74ac80622c346feabfff550a66959b984733a0c789c8302b" => :high_sierra
    sha256 "8250a3439ebefc4ff0f91c98cf3778398b100ff9aa9f66c2b5d2ad7102b53522" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libde265"
  depends_on "libpng"
  depends_on "x265"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "examples/example.heic"
  end

  test do
    output = "File contains 2 images"
    example = pkgshare/"example.heic"
    exout = testpath/"example.jpg"

    assert_match output, shell_output("#{bin}/heif-convert #{example} #{exout}")
    assert_predicate testpath/"example-1.jpg", :exist?
    assert_predicate testpath/"example-2.jpg", :exist?
  end
end
