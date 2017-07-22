class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/projects.php?Z1"
  url "https://github.com/michaelrsweet/htmldoc/releases/download/v1.9/htmldoc-1.9-source.tar.gz"
  sha256 "20ffc617f33e11aba7c726c32b23512c69fac0f6afb7fa8eec2c20b419fc0579"
  head "https://github.com/michaelrsweet/htmldoc.git"

  bottle do
    sha256 "6b70edb3af59a27af405046609f0beeed3c80fc05f75af8a3333386863115bbd" => :sierra
    sha256 "a8e329e977d7bd0f6a366e2109634d527d8953473515d0993072576fbab78a73" => :el_capitan
    sha256 "2b4d0403a450e761fcb833ccd6f7af9fcdef5de4f24bbaa13abfa449e965b196" => :yosemite
    sha256 "9afb3cda57a75cce5e631dbbe5df6dad8dfef4aa07837a1c0bbb1e4d4fc3d0c1" => :mavericks
  end

  depends_on "libpng"
  depends_on "jpeg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-ssl",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end
end
