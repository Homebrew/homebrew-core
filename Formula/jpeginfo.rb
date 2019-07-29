class Jpeginfo < Formula
  desc "Prints information and tests integrity of JPEG/JFIF files"
  homepage "https://www.kokkonen.net/tjko/projects.html"
  url "https://www.kokkonen.net/tjko/src/jpeginfo-1.6.1.tar.gz"
  sha256 "629e31cf1da0fa1efe4a7cc54c67123a68f5024f3d8e864a30457aeaed1d7653"
  revision 1

  bottle do
    cellar :any
    sha256 "ea481ba295f3e6a7dcaa4b220dc63ecbada6b652b5f4f83ad01d49dbbde96aaf" => :mojave
    sha256 "afafe6f163b0e058975470f6281907d125408e0c1c678ade5ef141024b6d20ed" => :high_sierra
    sha256 "0ec9e97f1ce99e36c9e5d4de8be48ca6b5bfc2d807ee590115426a7c57e26d00" => :sierra
    sha256 "ca1548c5ed9e3f18cf2e013f49d22a00276c9ef0b3d829fd256ae48178ed9974" => :el_capitan
    sha256 "d28d3fcbf355139760d15d1869f57d180940e8114b150446214b18270275dcf8" => :yosemite
  end

  depends_on "jpeg"

  def install
    ENV.deparallelize

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/jpeginfo", "--help"
  end
end
