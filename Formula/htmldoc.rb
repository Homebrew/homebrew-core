class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/archive/v1.9.12.tar.gz"
  sha256 "abeb50b9a0247fee4a83af98c56ba3bc35804f593af1893899de084830315a05"
  license "GPL-2.0-only"
  head "https://github.com/michaelrsweet/htmldoc.git"

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "7c02353667f8f762f0607c05d8387b0f77e848fac1d8f903533ed40a25667436"
    sha256 big_sur:       "a2ad4b8f476286d77cbf3c4c05f39bf0ef7d472b308fa8b11814cee4c090c224"
    sha256 catalina:      "f2dd1888010a9d29664f1ecac8ac3892b2aa95edeaf7b27f7dd48900ce45e824"
    sha256 mojave:        "b80236d31f3d87fbeba9908617f9868b8c0f998de5f72184684e60f7fe1ccef6"
  end

  depends_on "pkg-config" => :build
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
