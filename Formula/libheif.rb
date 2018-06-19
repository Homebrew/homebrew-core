class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "http://www.libheif.org"
  url "https://github.com/strukturag/libheif/releases/download/v1.3.2/libheif-1.3.2.tar.gz"
  sha256 "a9e12a693fc172baa16669f427063edd7bf07964a1cb623ee57cd056c06ee3fc"

  bottle do
    cellar :any
    sha256 "7ccc4bd4a25ad7132ddbc4361ad0c8d31d87ee1940d7d4ec13758a325d6e4dd1" => :high_sierra
    sha256 "6262a2acec9c692212f87ab556de4050d88c9bf44e6f4528a1a9210043d5ce39" => :sierra
    sha256 "59c5385f4a2ed0e11ebcfbcdfb5a15926b1a84d08296361f82396f7285472e09" => :el_capitan
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
