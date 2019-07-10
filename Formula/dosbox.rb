class Dosbox < Formula
  desc "DOS Emulator"
  homepage "https://www.dosbox.com/"
  url "https://downloads.sourceforge.net/project/dosbox/dosbox/0.74-3/dosbox-0.74-3.tar.gz"
  sha256 "c0d13dd7ed2ed363b68de615475781e891cd582e8162b5c3669137502222260a"

  bottle do
    cellar :any
    rebuild 2
    sha256 "f8936546b368cd8c05c00ce2f46fe43cc4bd100f76b9845c783b9a06a6a004b5" => :mojave
    sha256 "5116d754e9412089d741f29913adf1125cf8e7f46e3a06ab28caf36db88aa6b2" => :high_sierra
    sha256 "81e9f9bc8bad788c85d62875a5d4549732addae94c8eecb03c0f573a406f775b" => :sierra
  end

  head do
    url "https://svn.code.sf.net/p/dosbox/code-0/dosbox/trunk"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libpng"
  depends_on "sdl"
  depends_on "sdl_net"
  depends_on "sdl_sound"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
      --enable-core-inline
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/dosbox", "-version"
  end
end
