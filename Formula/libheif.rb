class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "http://www.libheif.org"
  url "https://github.com/strukturag/libheif/releases/download/v1.3.2/libheif-1.3.2.tar.gz"
  sha256 "a9e12a693fc172baa16669f427063edd7bf07964a1cb623ee57cd056c06ee3fc"

  bottle do
    cellar :any
    sha256 "415ac0e2a71c2fe93e0e0286a46f89ffa5332469fa2368533456ca3980e3348d" => :high_sierra
    sha256 "b2ebe1ffcc0ef68e527aeb906e69eeca4776dc777516ba0c42917d56b845e358" => :sierra
    sha256 "c76bfc6a4786ca45e6eb80ba6e4062b2e6f30d2c296e5ae53392c661652781e2" => :el_capitan
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
