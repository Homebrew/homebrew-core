class Dosbox < Formula
  desc "DOS Emulator"
  homepage "http://www.dosbox.com/"
  url "https://downloads.sourceforge.net/project/dosbox/dosbox/0.74/dosbox-0.74.tar.gz"
  sha256 "13f74916e2d4002bad1978e55727f302ff6df3d9be2f9b0e271501bd0a938e05"

  bottle do
    cellar :any
    revision 1
    sha256 "be37f802731de6700dd47252c9d5f8c6693aaa47849bde69e687647b44ec7ac7" => :yosemite
    sha256 "9c367cd50d5ace12040f9ce2b1dc1256b99a06be5d4ea32293b4a36eacb668c8" => :mavericks
    sha256 "0f084aebb29fa7ea7825f1a230c4ec825b7a1ee112bce2e3e4d256a9e737ff44" => :mountain_lion
  end

  head do
    url "http://svn.code.sf.net/p/dosbox/code-0/dosbox/trunk"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-debugger", "Enable internal debugger"

  depends_on "sdl"
  depends_on "sdl_net"
  depends_on "sdl_sound" => ["--with-libogg", "--with-libvorbis"]
  depends_on "libpng"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
      --enable-core-inline
    ]
    args << "--enable-debug" if build.with? "debugger"

    if build.head?
      # Prevent unstable build with clang
      # http://sourceforge.net/p/dosbox/code-0/3894/
      ENV.O0
    else
      # Disable dynamic cpu core recompilation that crashes on 64-bit platform
      # https://github.com/Homebrew/homebrew-games/issues/171
      args << "--disable-dynrec"
    end

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    DOSBox is not built for optimal performance due to unstability on 64-bit platform.
    EOS
  end

  test do
    system "#{bin}/dosbox", "-version"
  end
end
