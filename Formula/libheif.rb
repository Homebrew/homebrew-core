class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.6.0/libheif-1.6.0.tar.gz"
  sha256 "f00ad182cb21aa57218cb7ba222163376e74e3b7de1723fd789508a296c9e868"

  bottle do
    cellar :any
    sha256 "2a4e77094ff9668002f1344d51574538641384ab376e754c306d516bf95fdf81" => :catalina
    sha256 "243b22036e7de68c6e344422796e0229e8663c732d3891cead5e766823d1f939" => :mojave
    sha256 "f799050ed2c5a052a39506f65ba248557cd0b8dec6a816efbdf28aabacfd80de" => :high_sierra
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
