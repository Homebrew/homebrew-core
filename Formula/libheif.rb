class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.9.0/libheif-1.9.0.tar.gz"
  sha256 "b4acdbf3279115e4a681195c138c8b9f1bad1861b8dd5ae6033fd832b706c0ab"
  license "LGPL-3.0-only"

  bottle do
    cellar :any
    sha256 "e911fac255d148089a26e22b8fcc10be8d144619fcb2a7cc52636a18c2473b10" => :catalina
    sha256 "b2b006bc4cedeeab966379f0c738f4b95c2cbf6a65418d93b8871d8a4276ada2" => :mojave
    sha256 "42ff237b39838ff2fc5512763ef8c00207253ddf3a2317902b0cc85eb269ed01" => :high_sierra
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
