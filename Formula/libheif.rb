class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.3.2/libheif-1.3.2.tar.gz"
  sha256 "a9e12a693fc172baa16669f427063edd7bf07964a1cb623ee57cd056c06ee3fc"
  revision 1

  bottle do
    cellar :any
    sha256 "1a387d453a26fe836d19dbbe24e9be3e65c35603752d710af13ff48404951b3d" => :mojave
    sha256 "cde1636ed0b03d3dfbcae2b087297272b6b97767c0f34208976038d08650c7de" => :high_sierra
    sha256 "5864ceb38a0201878750294f9ce0fcbf5f31d10769fe9fbbf7f71d3dd1f2c219" => :sierra
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
