class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.6.0/libheif-1.6.0.tar.gz"
  sha256 "f00ad182cb21aa57218cb7ba222163376e74e3b7de1723fd789508a296c9e868"

  bottle do
    cellar :any
    sha256 "0fc77c14dc4528aab60296ca21e215202d1d5bb8eede62e9230d25ea956561a2" => :catalina
    sha256 "6a4a3ff9c1a9b85437866afd831f6287bc430b018b7b2ee1c5dcfdb3efcb4fe8" => :mojave
    sha256 "d9b96ad39ceb88a37b061a8588e9e6d434099b3d93d9a02104667b675e1c71c0" => :high_sierra
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
