class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/v4.1.tar.gz"
  sha256 "aee684cc4b6cd8f2f83196ebd42608b9917104c9b1572985797daf1ae68e5454"
  head "https://github.com/pdfpc/pdfpc.git"

  bottle do
    sha256 "ea0c731b612f89e6f76493155454a44a84a66f82399a3cd58f1caf2ce485bb9a" => :high_sierra
    sha256 "f450f182e9e260757977c209c36071bf4a28d6cb59e7ce941eb6b10af320ff7a" => :sierra
    sha256 "787d3ad90500210572de480501314b30ff0b5086b24e7fa6f5363efabf30f89c" => :el_capitan
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
