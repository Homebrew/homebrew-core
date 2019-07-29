class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/v4.3.4.tar.gz"
  sha256 "cc3ccd7a23990b76dd6083e774d28f63d726a86db3a7f180b1c90596b735d5ed"
  head "https://github.com/pdfpc/pdfpc.git"

  bottle do
    sha256 "80fa8e226eb146d7d5d04096ad69cbba4e1358f255ccf44333162eaec2ca0976" => :mojave
    sha256 "79745c4f54d0347251ae9dc09c9eeb3b5c12caffbe45d3da1d581c2002edafab" => :high_sierra
    sha256 "9142b108ce4ff8c361e293bf7f55efe4c7d0f5015eae64fb3055433d25766427" => :sierra
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
