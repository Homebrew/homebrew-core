class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.6.1/libheif-1.6.1.tar.gz"
  sha256 "a22611289464da08fa7e580c95ea5e1b1b522b96ee6807de9b3b4605efb621d1"

  bottle do
    cellar :any
    sha256 "c3872b30052b5560b79a5ab41960314b5f4f9a6ee7e2db740b70ef4ffd6ffe83" => :catalina
    sha256 "e3d14d604ca91f9bf3265d6dba3d66d098ba0339b91b3db7395f6e550298c4e4" => :mojave
    sha256 "076d461c72ca0651dd30f2a2ab7e701d4e39fbe2eebd895193eed785de37a9d3" => :high_sierra
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
