class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.7.0/libheif-1.7.0.tar.gz"
  sha256 "842a9ab4b8d6f0faf5a6dc5e8507321199ec44c0b1d8eb199f2de9b49e2db092"
  license "LGPL-3.0"

  bottle do
    cellar :any
    sha256 "dc3c55be447a590b3bfd0ba5e0a1bf1a79276a219123fdbf9d9dda5995a95de0" => :catalina
    sha256 "9c32b0a2b6ae5c3d9c60abb934ba7bd8f053a05c8ab2e2bc800604dee7ae227b" => :mojave
    sha256 "78e4531cd8bffbe9107ccea42db15f721e09edb6dd2957a0f6e723824415c456" => :high_sierra
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
