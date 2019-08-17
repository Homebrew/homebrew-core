class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.5.0/libheif-1.5.0.tar.gz"
  sha256 "0d03f59cb5a71fbe08f4ac72d2dc4d7888b91fa4ef8e1c80189df3ca08facdb9"

  bottle do
    cellar :any
    sha256 "a8f331547790724c76c1a1d3f2531e20d9f052c3b531097946889d3a61676075" => :mojave
    sha256 "262093043f4dca2f717bc3e6384c0f6ac9ce1f65d993f2a5431dd5dc76e0f7a9" => :high_sierra
    sha256 "1bcf57b648b50d68bd088e38097df7a5329f905a3794c426d2af78db95ea7e3c" => :sierra
  end

  depends_on "pkg-config" => :build
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
  end

  def post_install
    system Formula["shared-mime-info"].opt_bin/"update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
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
