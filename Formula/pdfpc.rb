class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files."
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/v4.0.7.tar.gz"
  sha256 "25d5aa2cce344f1554f1f45a7c1f636576587cfd553d75d704e0c95ae3b2a503"
  head "https://github.com/pdfpc/pdfpc.git"

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
