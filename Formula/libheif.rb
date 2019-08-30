class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.5.1/libheif-1.5.1.tar.gz"
  sha256 "b134d0219dd2639cc13b8a8bcb8f264834593dd0417da1973fbe96e810918a8b"

  bottle do
    cellar :any
    sha256 "26df3b363e558774c0468da7eca07d80ba4ef0e67693742fdb7111abb1fa4ee7" => :mojave
    sha256 "311f0337120691dbf5d13d9b68ce68b9ca2d8351431eb4f5ddb73983e8a3b498" => :high_sierra
    sha256 "39397b2dcb05f9ccdbc335470a5e6302cfa844183fdd4a6c6f177f6d69c665fe" => :sierra
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
