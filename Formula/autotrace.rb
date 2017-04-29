class Autotrace < Formula
  desc "Convert bitmap to vector graphics"
  homepage "https://autotrace.sourceforge.io"
  url "https://downloads.sourceforge.net/project/autotrace/AutoTrace/0.31.1/autotrace-0.31.1.tar.gz"
  sha256 "5a1a923c3335dfd7cbcccb2bbd4cc3d68cafe7713686a2f46a1591ed8a92aff6"
  revision 3

  bottle do
    cellar :any
    sha256 "c42f1c9bce94526b9c77f36658151dd45cfceeb1fcc5bf78ce896c1b59ca23cd" => :sierra
    sha256 "fcca0159cc773ecab656fdb869b758f09e22abd6fe2dcff1559626ea75cdfb85" => :el_capitan
    sha256 "fd6b429acb05f3e515fa07bcb92e7822dfdd7fd18647ddd94bb4032aaffa476d" => :yosemite
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

  test do
    assert_match version.to_s, shell_output("#{bin}/autotrace -version")

    # Prepare a bitmap `autotrace` can work with (there's something to trace).
    convert = Formula["imagemagick"].bin/"convert"
    system convert, test_fixtures("test.eps"), "test.tga"

    system bin/"autotrace", "-output-file", "test.eps", "test.tga"
    assert_predicate testpath/"test.eps", :exist?
  end
end
