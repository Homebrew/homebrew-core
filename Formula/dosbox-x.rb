class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "http://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/v0.801.tar.gz"
  sha256 "40f94cdcc5c9a374c522de7eb2c2288eaa8c6de85d0bd6a730f48bd5d84a89f9"
  revision 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  bottle do
    cellar :any
    sha256 "fb4c70a10846fe6b083e3a1f843df4ba22ee393cafaae31004053484d9ea2c40" => :sierra
    sha256 "611026f20695f797964e027ac1801256937a27857da6178b90b94cd9e437711f" => :el_capitan
    sha256 "f24bd885e75a4473f0caab1742b2df9c0562b3258d177cee3c01c1e5de7df1c3" => :yosemite
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

    # Fix compilation issue: https://github.com/joncampbell123/dosbox-x/pull/308
    if DevelopmentTools.clang_build_version >= 900
      inreplace "src/hardware/serialport/nullmodem.cpp",
                "setCD(clientsocket > 0)", "setCD(clientsocket != 0)"
    end

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
