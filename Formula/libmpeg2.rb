class Libmpeg2 < Formula
  desc "Library to decode mpeg-2 and mpeg-1 video streams"
  homepage "https://libmpeg2.sourceforge.io/"
  url "https://libmpeg2.sourceforge.io/files/libmpeg2-0.5.1.tar.gz"
  sha256 "dee22e893cb5fc2b2b6ebd60b88478ab8556cb3b93f9a0d7ce8f3b61851871d4"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://libmpeg2.sourceforge.io/downloads.html"
    regex(/href=.*?libmpeg2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_monterey: "53c217af18cab898a3583262ceeb010b754b4bedd8f781087725e0e13420014d"
    sha256 cellar: :any,                 arm64_big_sur:  "e2f1a24fdb40a15928f35ae84326fab5b8d1293ca2b378aee8e45aab9bb5766c"
    sha256 cellar: :any,                 monterey:       "34f4023a88e69b1c6e59a991dd64973280db238f57daa6dca61ee2da5d77bdbb"
    sha256 cellar: :any,                 big_sur:        "9f2cfd80d47e975333747fdea41d336071282ae359e9a345835a70611467bd43"
    sha256 cellar: :any,                 catalina:       "9a8c812495f38eb0d46bff246c632c5dfd97413b2bc949defd9c5d318b9da439"
    sha256 cellar: :any,                 mojave:         "81161223100cfa38704d3194519be5651f4fcb47765b7e99f1d53ce05e433142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe8cebc1c57f728d647e10b0d5bd67571274d5c856363e5f7f2959fdc529a3c1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "sdl"

  def install
    # Otherwise compilation fails in clang with `duplicate symbol ___sputc`
    ENV.append_to_cflags "-std=gnu89"

    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "doc/sample1.c"
  end

  test do
    system ENV.cc, "-I#{include}/mpeg2dec", pkgshare/"sample1.c", "-L#{lib}", "-lmpeg2"
  end
end
