class Abuse < Formula
  desc "Dark 2D side-scrolling platform game"
  homepage "http://abuse.zoy.org/"
  url "http://abuse.zoy.org/raw-attachment/wiki/download/abuse-0.8.tar.gz"
  sha256 "0104db5fd2695c9518583783f7aaa7e5c0355e27c5a803840a05aef97f9d3488"
  head "svn://svn.zoy.org/abuse/abuse/trunk"

  bottle do
    cellar :any
    sha256 "e2dd02d540aabb2943823051e4bf80ea1fbb80da1725462fb314f53a0c6800b2" => :mojave
    sha256 "3fdc2ccd00bf320b994747d982b5cbde4b73c45c094c9a0f89acf13aea3eb847" => :high_sierra
    sha256 "6971b6eebf4c00eaaed72a1104a49be63861eabc95d679a0c84040398e320059" => :sierra
    sha256 "456dfbfb6e7486d0c5a50ac01423efabf5243b08d3235c83477681090a42c652" => :el_capitan
    sha256 "3ca083d0d99c00ad26f306c026ef35ee565a24f0171b94457deb64d5e170edf9" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libvorbis"
  depends_on "sdl"
  depends_on "sdl_mixer"

  def startup_script
    <<~EOS
      #!/bin/bash
      #{libexec}/abuse-bin -datadir "#{pkgshare}" "$@"
    EOS
  end

  def install
    # Hack to work with newer versions of automake
    inreplace "bootstrap", "11 10 9 8 7 6 5", '$(seq -s " " 5 99)'

    # Add SDL.m4 to aclocal includes
    inreplace "bootstrap",
      "aclocal${amvers} ${aclocalflags}",
      "aclocal${amvers} ${aclocalflags} -I#{HOMEBREW_PREFIX}/share/aclocal"

    # undefined
    inreplace "src/net/fileman.cpp", "ushort", "unsigned short"
    inreplace "src/sdlport/setup.cpp", "UInt8", "uint8_t"

    # Fix autotools obsoletion notice
    inreplace "configure.ac", "AM_CONFIG_HEADER", "AC_CONFIG_HEADERS"

    # Re-enable OpenGL detection
    inreplace "configure.ac",
      "#error\t/* Error so the compile fails on OSX */",
      "#include <OpenGL/gl.h>"

    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-sdltest",
                          "--with-assetdir=#{pkgshare}",
                          "--with-sdl-prefix=#{Formula["sdl"].opt_prefix}"

    # Use Framework OpenGL, not libGl
    %w[. src src/imlib src/lisp src/net src/sdlport].each do |p|
      inreplace "#{p}/Makefile", "-lGL", "-framework OpenGL"
    end

    system "make"

    bin.install "src/abuse-tool"
    libexec.install "src/abuse" => "abuse-bin"
    pkgshare.install Dir["data/*"] - %w[data/Makefile data/Makefile.am data/Makefile.in]
    # Use a startup script to find the game data
    (bin/"abuse").write startup_script
  end

  def caveats
    <<~EOS
      Game settings and saves will be written to the ~/.abuse folder.
    EOS
  end

  test do
    system "#{bin}/abuse", "--help"
  end
end
