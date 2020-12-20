class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/v4.5.0.tar.gz"
  sha256 "e53ede1576da55403bba23671df5b946c756ec83ba30fbeb0cb7302f28b54a64"
  license "GPL-2.0-or-later"
  head "https://github.com/pdfpc/pdfpc.git"

  bottle do
    sha256 "f7ec854f156648a550bdeb912af1be98c91a84633d9eb789892d5c3d90e067ba" => :big_sur
    sha256 "f51bac229c55f8b5781804bd47cffe72d8acfb47b9447e3f02fc998c8abd9526" => :catalina
    sha256 "893f490903ffd59dd8c7fdba0a9f6c6a91dc320056d8ddff940422ba5429fcd0" => :mojave
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
