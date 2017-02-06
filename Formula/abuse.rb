class Abuse < Formula
  desc "dark 2D side-scrolling platform game"
  homepage "http://abuse.zoy.org/"
  url "http://abuse.zoy.org/raw-attachment/wiki/download/abuse-0.8.tar.gz"
  sha256 "0104db5fd2695c9518583783f7aaa7e5c0355e27c5a803840a05aef97f9d3488"
  head "svn://svn.zoy.org/abuse/abuse/trunk"

  bottle do
    cellar :any
    sha256 "cb60b8b12112e3c18080db23624aa9d3fd9217aff9254f2c6c76df99b4f03284" => :yosemite
    sha256 "0ad33d743c8f6bfab8b1a6b0a85657ab27309cd95c2df478439dc3b21dd3cc0b" => :mavericks
    sha256 "aeb28d6f8d8ec88838f462619975642649397e9a0122cadbee32e0bd5200fdf6" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl"
  depends_on "sdl_mixer"
  depends_on "libvorbis"

  def startup_script; <<-EOS.undent
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

  def caveats; <<-EOS.undent
      Game settings and saves will be written to the ~/.abuse folder.
    EOS
  end

  test do
    system "#{bin}/abuse", "--help"
  end
end
