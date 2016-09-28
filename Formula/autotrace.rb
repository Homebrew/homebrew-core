class Autotrace < Formula
  desc "Convert bitmap to vector graphics"
  homepage "http://autotrace.sourceforge.net"
  url "https://downloads.sourceforge.net/project/autotrace/AutoTrace/0.31.1/autotrace-0.31.1.tar.gz"
  sha256 "5a1a923c3335dfd7cbcccb2bbd4cc3d68cafe7713686a2f46a1591ed8a92aff6"
  revision 1

  bottle do
    cellar :any
    sha256 "519c8f834523db2e08bd31bae0a1537b4bf46184fa207132cd80a4823c0a24cb" => :sierra
    sha256 "73ec2093a38b49bda566f1287b3608f8361789577ec73dc8199428335d30c23f" => :el_capitan
    sha256 "e7127e4e07d276a681a49f33c3d856e1748c7bd31a520e2913b19ddafc916eaf" => :yosemite
    sha256 "995bc9a9485d627a66a55b80c8572886642b7e96793b4278a5f1cd3434c92d36" => :mavericks
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
