class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/v4.4.0.tar.gz"
  sha256 "5fc457b081cdf02708436bb708940fd6b689e03fc336d3faab652f0b85592c00"
  head "https://github.com/pdfpc/pdfpc.git"

  bottle do
    rebuild 1
    sha256 "b65b794725b5c60423cb97f6283aac5a7e4c348a112aad160605501eed96b7dd" => :catalina
    sha256 "0549b04e7edd7cb9831d5981fb43ad8e0ae92459f5c00b2e80520f32b6d1bf84" => :mojave
    sha256 "ab33199fc0198e8ec4fe35811a86d7c475eef84359ed03b42633515731b8542c" => :high_sierra
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
