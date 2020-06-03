class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.7.0/libheif-1.7.0.tar.gz"
  sha256 "842a9ab4b8d6f0faf5a6dc5e8507321199ec44c0b1d8eb199f2de9b49e2db092"

  bottle do
    cellar :any
    sha256 "c510386a4b5a0188da1351870f42c8511d30bea4657e0c90075846070b25ae83" => :catalina
    sha256 "ea60c2ab9766cbfa9c4d15e6440434f56f3de490a7d8aad75904a18c61fd0326" => :mojave
    sha256 "552a2dd021b6e6ec56246ee395b19881188b09c8bc2ded205cfb231709e2e4f3" => :high_sierra
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
