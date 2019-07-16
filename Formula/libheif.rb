class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.4.0/libheif-1.4.0.tar.gz"
  sha256 "977a9831f1d61b5005566945c7e16e31de35a57a8dd6eb715ae0f40a3595cb60"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "14cc90dd473ae07dd74259700932ac66ecc49d8fc0e2c7b4602e4c62e02ac7a6" => :mojave
    sha256 "a32d9957f16fceef1061b3ba2b3da14087a4a60c82df0bc8a44214972f3f48b4" => :high_sierra
    sha256 "118fe6fa0f64832130e8c3134c0d345abb0f84d6cefd9799f5e84a051d3b7390" => :sierra
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
