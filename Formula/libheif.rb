class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.6.2/libheif-1.6.2.tar.gz"
  sha256 "bb229e855621deb374f61bee95c4642f60c2a2496bded35df3d3c42cc6d8eefc"
  revision 1

  bottle do
    cellar :any
    sha256 "8c9daabc72f34cc6857eb44e9df06552566fe882ae08d8ad5523033ae9244801" => :catalina
    sha256 "f2aa48c55af55eb96b0a89b3304ca4d00f58230d4cb52dc78ffc90aafa6b1566" => :mojave
    sha256 "c5fae5aa144507a302571fcf5b99259b1cb9c659dcd26f5369538203a2e6c5fa" => :high_sierra
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
