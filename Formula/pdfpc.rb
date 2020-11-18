class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/v4.4.1.tar.gz"
  sha256 "4adb42fd1844a7e2ab44709dd043ade618c87f2aaec03db64f7ed659e8d3ddad"
  license "GPL-2.0-or-later"
  head "https://github.com/pdfpc/pdfpc.git"

  bottle do
    sha256 "c1e404b1f9ab52f405cbb8122cb2e238c44efb5b848c6eb666faad594495c4e9" => :big_sur
    sha256 "aa21bf874d02d920eefc1ec3d8b2ce35cac2712a18d18817d1cbb0594639fb9d" => :catalina
    sha256 "85befb240c734d282ed137ebec82ed69da0b62ee9cf72288e7c052030e0daf56" => :mojave
    sha256 "028edb85cd773f143754f616fb54064d60126316de3330e9dc67f6332d9b5f09" => :high_sierra
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
