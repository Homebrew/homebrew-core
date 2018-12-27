class Dosbox < Formula
  desc "DOS Emulator"
  homepage "https://www.dosbox.com/"
  url "https://downloads.sourceforge.net/project/dosbox/dosbox/0.74-2/dosbox-0.74-2.tar.gz"
  sha256 "7077303595bedd7cd0bb94227fa9a6b5609e7c90a3e6523af11bc4afcb0a57cf"

  bottle do
    cellar :any
    sha256 "77002281feccd4fcf02b6f8c0c2e8cb5c2e2ef7b51b1dd22ee2e0e990e893ab3" => :mojave
    sha256 "5e224efd3dd3ee4891158e340b3974c762cfd293250d0008fd652386603433cc" => :high_sierra
    sha256 "f15fa16434d0cd2784aa1eb3d540ef0c964b438857642f450e96542fc2377493" => :sierra
    sha256 "bf86acc4d071649e227b724fc2c16515fce3e780e8c7d3900ee16c8bda497398" => :el_capitan
  end

  head do
    url "http://svn.code.sf.net/p/dosbox/code-0/dosbox/trunk"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-debugger", "Enable internal debugger"

  depends_on "libpng"
  depends_on "ncurses" if build.with?("debugger")
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
    args << "--enable-debug" if build.with? "debugger"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/dosbox", "-version"
  end
end
