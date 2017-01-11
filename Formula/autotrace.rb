class Autotrace < Formula
  desc "Convert bitmap to vector graphics"
  homepage "http://autotrace.sourceforge.net"
  url "https://downloads.sourceforge.net/project/autotrace/AutoTrace/0.31.1/autotrace-0.31.1.tar.gz"
  sha256 "5a1a923c3335dfd7cbcccb2bbd4cc3d68cafe7713686a2f46a1591ed8a92aff6"
  revision 3

  bottle do
    cellar :any
    sha256 "3e7e11a55fc00336ea8ae33fb77ce6f74b30ced7807818d0e91cf60dcf3d91ed" => :sierra
    sha256 "db6a3b005b2a6691b44831fe8683e583199b7ca39eea22505e4f23c96693c42d" => :el_capitan
    sha256 "a9f4eec90bd575a1a6ed721d0d0b32b9184d9815cbeb537926d13ee7c1a0008f" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "imagemagick" => :recommended

  # Issue 16569: Use MacPorts patch to port input-png.c to libpng 1.5.
  # Fix underquoted m4
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/5b41470/autotrace/patch-libpng-1.5.diff"
    sha256 "9c57a03d907db94956324e9199c7b5431701c51919af6dfcff4793421a1f31fe"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/5b41470/autotrace/patch-autotrace.m4.diff"
    sha256 "12d794c99938994f5798779ab268a88aff56af8ab4d509e14383a245ae713720"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    args << "--without-magick" if build.without? "imagemagick"

    system "./configure", *args
    system "make", "install"
  end
end
