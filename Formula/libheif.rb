class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.4.0/libheif-1.4.0.tar.gz"
  sha256 "977a9831f1d61b5005566945c7e16e31de35a57a8dd6eb715ae0f40a3595cb60"

  bottle do
    cellar :any
    sha256 "b79d458a5b9b582904c38c2d4f0b05bb069863811dea7b5b695caaaef3bb2b08" => :mojave
    sha256 "a991b6fd3bd4690d7e4dac089b5830ede7035927e89d26371f9385c6f8f2a491" => :high_sierra
    sha256 "ddc2f6949d0ffb2da755fe900ecc09519797bc302ca5f74d53ad7e76b86df1e8" => :sierra
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
