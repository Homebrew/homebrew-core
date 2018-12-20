class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/v4.3.0.tar.gz"
  sha256 "15bb8f202988a978635f9b569f57be6dfe6e29e8ed3fc4929781cf8ef553ea2a"
  head "https://github.com/pdfpc/pdfpc.git"

  bottle do
    sha256 "589693b5df5baa5ecf2bdb6b05151dffb9eb3c3be8fea620c37f452e384dee79" => :mojave
    sha256 "eb57ff921249cd46593a2119bf43f9f4a12fc9a460cca39ee6f40e118fb24559" => :high_sierra
    sha256 "de61ba7baccd09df8792f73f2fa2469d0b91aacda1a186fa235878e3f824fa2a" => :sierra
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
