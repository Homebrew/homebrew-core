class Dosbox < Formula
  desc "DOS Emulator"
  homepage "https://www.dosbox.com/"
  url "https://downloads.sourceforge.net/project/dosbox/dosbox/0.74/dosbox-0.74.tar.gz"
  sha256 "13f74916e2d4002bad1978e55727f302ff6df3d9be2f9b0e271501bd0a938e05"

  bottle do
    cellar :any
    sha256 "390e2b95a940e1f3f7e73566fe85b998bfff1d5331616a8b9e35e1204bdb06ef" => :sierra
    sha256 "9c79e172494877d82dce3842aa07109823458342d6f4f7b221d5a2225ca27de5" => :el_capitan
    sha256 "8f8b3b6ed1260f3ef74cb281711fea046e315ce20c169a0b76a1f5efa40146f8" => :yosemite
  end

  head do
    url "https://svn.code.sf.net/p/dosbox/code-0/dosbox/trunk"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-debugger", "Enable internal debugger"

  depends_on "sdl"
  depends_on "sdl_net"
  depends_on "sdl_sound" => ["--with-libogg", "--with-libvorbis"]
  depends_on "libpng"

  conflicts_with "dosbox-x", :because => "both install `dosbox` binaries"

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
      # https://sourceforge.net/p/dosbox/code-0/3894/
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
