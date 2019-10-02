class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.5.1/libheif-1.5.1.tar.gz"
  sha256 "b134d0219dd2639cc13b8a8bcb8f264834593dd0417da1973fbe96e810918a8b"

  bottle do
    cellar :any
    sha256 "28833a4c3ca9806930944f3f714ea95ec7d5c2e8e9b7120cf32d212aa350c772" => :catalina
    sha256 "09b000d29523544e6ebbaabce1550b6e51575d3b61522621e01efd7a8fab1622" => :mojave
    sha256 "2d1831b3668450da2d30befc0caa18916cdd429a1c9f22557ec03e3e584549db" => :high_sierra
    sha256 "9bee18eba422e4c23bf6260321d9a1680a7ba795e9d983e5c628ac0bf1d108e0" => :sierra
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
