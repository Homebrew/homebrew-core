class Extractpdfmark < Formula
  desc "Extract page mode and named destinations as PDFmark from PDF"
  homepage "https://www.ctan.org/pkg/extractpdfmark"
  url "https://mirrors.ctan.org/support/extractpdfmark.zip"
  version "1.1.0"
  sha256 "f4a5ec1c6944e896bc52f2af9231e98a2c5b68f076ef9341146b829815366b28"
  license "GPL-3.0-or-later"

  revision 1

  depends_on "poppler" => :build
  depends_on "gettext"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/extractpdfmark", "--version"
  end
end
