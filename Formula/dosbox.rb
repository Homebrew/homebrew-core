class Dosbox < Formula
  desc "DOS Emulator"
  homepage "https://www.dosbox.com/"
  url "https://downloads.sourceforge.net/project/dosbox/dosbox/0.74/dosbox-0.74.tar.gz"
  sha256 "13f74916e2d4002bad1978e55727f302ff6df3d9be2f9b0e271501bd0a938e05"
  revision 1

  bottle do
    cellar :any
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

  # Fix compilation with Xcode 9
  # https://sourceforge.net/p/dosbox/patches/274/
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/9102536006/dosbox/xcode9.patch"
      sha256 "a23a4cf691452e5d13e159063d9cd8b9bd508c4982116b471fd6fa72fc021eba"
    end
  end

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

  def caveats; <<~EOS
    DOSBox is not built for optimal performance due to unstability on 64-bit platform.
    EOS
  end

  test do
    system "#{bin}/dosbox", "-version"
  end
end
