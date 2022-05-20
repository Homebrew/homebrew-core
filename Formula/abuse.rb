class Abuse < Formula
  desc "Dark 2D side-scrolling platform game"
  homepage "http://abuse.zoy.org/"
  url "http://abuse.zoy.org/raw-attachment/wiki/download/abuse-0.8.tar.gz"
  sha256 "0104db5fd2695c9518583783f7aaa7e5c0355e27c5a803840a05aef97f9d3488"
  license all_of: [:public_domain, "GPL-2.0-or-later", "WTFPL"]
  head "svn://svn.zoy.org/abuse/abuse/trunk"

  livecheck do
    url "http://abuse.zoy.org/wiki/download"
    regex(/href=.*?abuse[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "a65b0ae9c8bbfc5c58e3650983d2be5a9e308ca45e325b4884504a1b389dcd84"
    sha256 cellar: :any, arm64_big_sur:  "02c9bc66fbd8460ea0ecc0479806ab7e6a2ff982d38bd16068eba21348d54e41"
    sha256 cellar: :any, monterey:       "454a93ef2407bec483792814dbde42b6e419ee6f46ea3db04f782b20f10c9748"
    sha256 cellar: :any, big_sur:        "48a11a0a5f7f34c85c30b0cc4f259ea0352043b4c3e9dc81f2e4d8a743270edb"
    sha256 cellar: :any, catalina:       "669679d60bb64b08d940f9f7c4b29faf340ff081d62b66f1764087db466fffe2"
    sha256 cellar: :any, mojave:         "e2dd02d540aabb2943823051e4bf80ea1fbb80da1725462fb314f53a0c6800b2"
    sha256 cellar: :any, high_sierra:    "3fdc2ccd00bf320b994747d982b5cbde4b73c45c094c9a0f89acf13aea3eb847"
    sha256 cellar: :any, sierra:         "6971b6eebf4c00eaaed72a1104a49be63861eabc95d679a0c84040398e320059"
    sha256 cellar: :any, el_capitan:     "456dfbfb6e7486d0c5a50ac01423efabf5243b08d3235c83477681090a42c652"
    sha256 cellar: :any, yosemite:       "3ca083d0d99c00ad26f306c026ef35ee565a24f0171b94457deb64d5e170edf9"
    sha256               x86_64_linux:   "24da6cb770bbe2405b4e546ce768fbf15869029b8d9eb3af0fc1610375664f3c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libvorbis"
  depends_on "sdl"
  depends_on "sdl_mixer"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

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

    if OS.mac?
      # Use Framework OpenGL, not libGl
      %w[. src src/imlib src/lisp src/net src/sdlport].each do |p|
        inreplace "#{p}/Makefile", "-lGL", "-framework OpenGL"
      end
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
    # Fails in Linux CI with "Unable to initialise SDL : No available video device"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "#{bin}/abuse", "--help"
  end
end
