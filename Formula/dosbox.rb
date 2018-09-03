class Dosbox < Formula
  desc "DOS Emulator"
  homepage "https://www.dosbox.com/"
  url "https://downloads.sourceforge.net/project/dosbox/dosbox/0.74-2/dosbox-0.74-2.tar.gz"
  sha256 "7077303595bedd7cd0bb94227fa9a6b5609e7c90a3e6523af11bc4afcb0a57cf"

  bottle do
    cellar :any
    sha256 "7d75c53e7f6a2c63968261127b64664a4fb372f51e6016c851d154c36ef5fcba" => :mojave
    sha256 "2bcbcf0f95569cd6c4d6dbbbf6578c3573fdabf7069708ed191cfbf1430b6bbb" => :high_sierra
    sha256 "977fbb45ec74f10f20055d0d7b5732f8af281c8289914b8895b16db25798c1f5" => :sierra
    sha256 "2eedf84b070caaf0af61ff1ef51c82a16ae56e7ca498c832e817376cd382b453" => :el_capitan
    sha256 "476cfcd94ec00d9a04ff125ac0b6513fe681ebe976e729605e5519ca230664a7" => :yosemite
  end

  head do
    url "https://svn.code.sf.net/p/dosbox/code-0/dosbox/trunk"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-debugger", "Enable internal debugger"

  depends_on "sdl"
  depends_on "sdl_net"
  depends_on "sdl_sound"
  depends_on "libpng"
  depends_on "ncurses" if build.with?("debugger")

  conflicts_with "dosbox-x", :because => "both install `dosbox` binaries"

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
