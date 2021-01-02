class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/v4.4.1.tar.gz"
  sha256 "4adb42fd1844a7e2ab44709dd043ade618c87f2aaec03db64f7ed659e8d3ddad"
  license "GPL-2.0-or-later"
  revision 1
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
