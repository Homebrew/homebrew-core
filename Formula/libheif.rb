class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.10.0/libheif-1.10.0.tar.gz"
  sha256 "ad5af1276f341277dc537b0d19a4193e0833c247b2aacb936e0c5494141533ae"
  license "LGPL-3.0-only"

  bottle do
    cellar :any
    sha256 "f137ce4e87878830da9c912f2e6db89f41ae086bb3057695f15dbdc0b8bbf96d" => :big_sur
    sha256 "cfbf48ac25a4a2d5c193837a03ad99abd2097f8be642c1fd234eebe082bdc4da" => :catalina
    sha256 "68c9d90b2bb7325b34f18cf5bd175e8df8cd177bc0325fd13e327e81481a3d1c" => :mojave
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
