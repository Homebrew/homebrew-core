class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/v4.3.2.tar.gz"
  sha256 "44b487ea207bac88364e136570d4d4baaec08cfd1388e3477fb52a36b6c57f29"
  head "https://github.com/pdfpc/pdfpc.git"

  bottle do
    sha256 "265a44f7291d6305f93026167a3ebe49454cc50df1ca9e8ee0b84bbfe6c97614" => :mojave
    sha256 "2e49ec7fe28511d0624c2163edbe263501c2090562d600d70b201fec4e308347" => :high_sierra
    sha256 "2c106b929431db40e18755f1c1d7586bbf73916bc88a6b003ce4ed6462051b91" => :sierra
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
