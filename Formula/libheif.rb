class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.6.2/libheif-1.6.2.tar.gz"
  sha256 "bb229e855621deb374f61bee95c4642f60c2a2496bded35df3d3c42cc6d8eefc"
  revision 1

  bottle do
    cellar :any
    sha256 "2d6e5b63b3a3dc455a33814b868a4785dff589a077bef534937972d8f4026f6e" => :catalina
    sha256 "c5d12260701a92ad83a2e71dde7ae0d599e94848b0aafe8128d628d986c52d5a" => :mojave
    sha256 "bd532f0e7f4071a90750655085ea5d19a29887b7aafed21a5325dceb3595dbc9" => :high_sierra
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
