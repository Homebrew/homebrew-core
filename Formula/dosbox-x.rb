class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "http://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/v0.801.tar.gz"
  sha256 "40f94cdcc5c9a374c522de7eb2c2288eaa8c6de85d0bd6a730f48bd5d84a89f9"
  revision 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  bottle do
    cellar :any
    sha256 "8a727059fa9d789963220e52492ac7045ef98cfb7224883610c486568cdd864c" => :sierra
    sha256 "ba30889dd69d459b4e40a5492a185d37182087f9dc1d92dd2a4ca9d5135aa8a5" => :el_capitan
    sha256 "b941f63418e748914fbab2e346d5a7acc9f8458adfba4685cd60eaa82771e109" => :yosemite
  end

  depends_on "sdl"
  depends_on "sdl_net"
  depends_on "sdl_sound"
  depends_on "libpng"
  depends_on "fluid-synth"

  # Otherwise build failure on Moutain Lion (#311)
  needs :cxx11

  conflicts_with "dosbox", :because => "both install `dosbox` binaries"

  def install
    ENV.cxx11

    # Fix build failure due to missing <remote-ext.h> included from pcap.h
    # https://github.com/joncampbell123/dosbox-x/issues/275
    inreplace "src/hardware/ne2000.cpp", "#define HAVE_REMOTE\n", ""

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
      --enable-core-inline
    ]
    args << "--enable-debug" if build.with? "debugger"

    system "./configure", *args
    chmod 0755, "install-sh"
    system "make", "install"
  end

  test do
    assert_match /DOSBox version #{version}/, shell_output("#{bin}/dosbox -version 2>&1", 1)
  end
end
