class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/archive/v1.9.11.tar.gz"
  sha256 "eaa994270dc05ab52d57ed738128370ba783989e97687801fe3c12f445af0d05"
  license "GPL-2.0-only"
  head "https://github.com/michaelrsweet/htmldoc.git"

  bottle do
    rebuild 1
    sha256 "a2ad4b8f476286d77cbf3c4c05f39bf0ef7d472b308fa8b11814cee4c090c224" => :big_sur
    sha256 "7c02353667f8f762f0607c05d8387b0f77e848fac1d8f903533ed40a25667436" => :arm64_big_sur
    sha256 "f2dd1888010a9d29664f1ecac8ac3892b2aa95edeaf7b27f7dd48900ce45e824" => :catalina
    sha256 "b80236d31f3d87fbeba9908617f9868b8c0f998de5f72184684e60f7fe1ccef6" => :mojave
  end

  depends_on "jpeg"
  depends_on "libpng"

  def install
    system "./configure", "--disable-debug",
                          "--disable-ssl",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/htmldoc", "--version"
  end
end
