class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/v4.4.0.tar.gz"
  sha256 "5fc457b081cdf02708436bb708940fd6b689e03fc336d3faab652f0b85592c00"
  head "https://github.com/pdfpc/pdfpc.git"

  bottle do
    sha256 "869f8e2a9071f7bf091dff66f1dfe21cd5a756b33c380a2cc34c256e5400d373" => :catalina
    sha256 "a8da451706b359b4618ec80d3cdae7f6de5e2ba38e44e10a1a4c38d5fc244ca7" => :mojave
    sha256 "c3b6c37f3ffd66d6bca06e2616f8a64ab91f26d98e126c10d0a94e2a31bef3e2" => :high_sierra
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
