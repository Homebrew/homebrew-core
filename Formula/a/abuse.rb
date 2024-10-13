class Abuse < Formula
  desc "Dark 2D side-scrolling platform game"
  homepage "http://abuse.zoy.org/"
  url "http://abuse.zoy.org/raw-attachment/wiki/download/abuse-0.8.tar.gz"
  sha256 "0104db5fd2695c9518583783f7aaa7e5c0355e27c5a803840a05aef97f9d3488"
  license all_of: [:public_domain, "GPL-2.0-or-later", "WTFPL"]
  revision 1
  head "svn://svn.zoy.org/abuse/abuse/trunk"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "f800e37b36fdb7e2961f9a0e53c0533e572a75fa999e441fe777576ceec0af24"
    sha256 cellar: :any, arm64_ventura:  "4439cf6dd233b641848c36576ca622700de8c1efeb0a966e862c0e4dfc925b90"
    sha256 cellar: :any, arm64_monterey: "f9c0ad01bf244402da95d81a483a46d8bcc45fdaa50dde524711db05f5051438"
    sha256 cellar: :any, arm64_big_sur:  "487a8f37d5f3b9313d0d83a7e7349ce3c5111b1dc21b4d75c36b8a1e14a7aec3"
    sha256 cellar: :any, sonoma:         "fe35373e694cfe8381516931e8c394d0d549dfc352956191404a694beeed6a7e"
    sha256 cellar: :any, ventura:        "aac3e824b3bc85336d0d2658a7ae1a0f2095d589b8f42ef3ea8e77e85d6871f3"
    sha256 cellar: :any, monterey:       "1902270b9c53512d7d4770c5c8f1b40f7670539befd7e6e4f95b67b3248c1782"
    sha256 cellar: :any, big_sur:        "3a30d73be5603120665da70ffc53bf27c92196b582aa53bc62e40296a3a625d0"
    sha256 cellar: :any, catalina:       "39183111fb8c61401824df809e46d09857f1d37e49703e993cc221406d0cc7ae"
    sha256               x86_64_linux:   "99bb1d87aef39b46eb39d0b6d9483afa3052bb0e616a16bbea90798545f1db37"
  end

  # Uses deprecated `sdl_mixer`. HEAD does have support for SDL 2 but wasn't released.
  # Last release on 2011-05-09 and last SVN revision on 2014-07-21
  disable! date: "2024-01-02", because: :unmaintained

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libvorbis"
  depends_on "sdl12-compat"
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
                          "--with-sdl-prefix=#{Formula["sdl12-compat"].opt_prefix}"

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

    system bin/"abuse", "--help"
  end
end
