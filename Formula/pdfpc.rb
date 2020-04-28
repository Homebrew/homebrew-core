class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/v4.4.0.tar.gz"
  sha256 "5fc457b081cdf02708436bb708940fd6b689e03fc336d3faab652f0b85592c00"
  revision 2
  head "https://github.com/pdfpc/pdfpc.git"

  bottle do
    sha256 "43abe4c41bd280a367c6691f6dc34e0b68cb0977b86890dde9fdf4c40ec89660" => :catalina
    sha256 "d6d0f8cd968ddd671f9b2cae13fed8cb1db3ddf8b300bfc6e4ef286a311ef817" => :mojave
    sha256 "8426b09f609647f0487fbdfae29b2f86b81e7a783a94ad9be0dc94094d33ec2f" => :high_sierra
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
