class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/v4.3.2.tar.gz"
  sha256 "44b487ea207bac88364e136570d4d4baaec08cfd1388e3477fb52a36b6c57f29"
  revision 1
  head "https://github.com/pdfpc/pdfpc.git"

  bottle do
    sha256 "58d09f41d494caa8b715b89618865fbcf97a0939257ed8d68b78a96cf7adf572" => :mojave
    sha256 "e3dc005c7499f476836d2567ca40292cc611b77fc430d829845655dc9c35d409" => :high_sierra
    sha256 "79dc6a0183f42c641554578f94a32bda35ac4658f39b78125d745113cb57b85a" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "vala" => :build
  depends_on "gtk+3"
  depends_on "libgee"
  depends_on "librsvg"
  depends_on "poppler"

  def install
    system "cmake", ".", "-DMOVIES=off", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/pdfpc", "--version"
  end
end
