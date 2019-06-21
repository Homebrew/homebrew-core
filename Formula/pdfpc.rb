class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/v4.3.4.tar.gz"
  sha256 "cc3ccd7a23990b76dd6083e774d28f63d726a86db3a7f180b1c90596b735d5ed"
  head "https://github.com/pdfpc/pdfpc.git"

  bottle do
    sha256 "58d09f41d494caa8b715b89618865fbcf97a0939257ed8d68b78a96cf7adf572" => :mojave
    sha256 "e3dc005c7499f476836d2567ca40292cc611b77fc430d829845655dc9c35d409" => :high_sierra
    sha256 "79dc6a0183f42c641554578f94a32bda35ac4658f39b78125d745113cb57b85a" => :sierra
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
