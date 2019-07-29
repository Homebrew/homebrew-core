class Dosbox < Formula
  desc "DOS Emulator"
  homepage "https://www.dosbox.com/"
  url "https://downloads.sourceforge.net/project/dosbox/dosbox/0.74-3/dosbox-0.74-3.tar.gz"
  sha256 "c0d13dd7ed2ed363b68de615475781e891cd582e8162b5c3669137502222260a"

  bottle do
    cellar :any
    sha256 "de46ee6c3c638829ba3b9dc3ee009811d26a19359d10804b9ff93706df2a6863" => :mojave
    sha256 "66b1b073b1ae7db629c64f66249254aefcb8fb6585c065c858a364bd258785d4" => :high_sierra
    sha256 "3bd2c41c7f76e214c0964acec02723d2a2a611eca92cf5edb93c029333a78adf" => :sierra
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
