class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/v4.4.0.tar.gz"
  sha256 "5fc457b081cdf02708436bb708940fd6b689e03fc336d3faab652f0b85592c00"
  revision 3
  head "https://github.com/pdfpc/pdfpc.git"

  bottle do
    sha256 "c68764210cf9dc8564a85f530ee268a1d90392decaba4428170ee37ec0d81bf5" => :catalina
    sha256 "6195d7e39c705c40babe547629bc5993b49585e30903b4d5eb4c7cca4f4c8f47" => :mojave
    sha256 "636ca9b39c17c1653721556efb3ecc435584b4679208580d93578eebbb137d23" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "vala" => :build
  depends_on "gst-plugins-good"
  depends_on "gtk+3"
  depends_on "libgee"
  depends_on "librsvg"
  depends_on "poppler"

  def install
    system "cmake", ".", "-DMOVIES=on", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/pdfpc", "--version"
  end
end
