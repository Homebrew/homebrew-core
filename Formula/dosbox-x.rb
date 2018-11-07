class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "http://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/v0.801.tar.gz"
  sha256 "40f94cdcc5c9a374c522de7eb2c2288eaa8c6de85d0bd6a730f48bd5d84a89f9"
  revision 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5bccafd80948d5ef2ef3059eae718d1c025880a83c065533daa7befe1bd4cae2" => :mojave
    sha256 "8cbaa0cf9658118b4b4ba32f4d1718f9bf49d0aec71cc7846463f37966559656" => :high_sierra
    sha256 "d3fc4b2bd340ed6f7d2624b8daf95397891f8e142d6219437f2cae215f538216" => :sierra
    sha256 "0b5098e3397a15804a300540be53c98f862c4f7276eb4c1de7966152421a9392" => :el_capitan
  end

  depends_on "fluid-synth"
  depends_on "libpng"
  depends_on "sdl"
  depends_on "sdl_net"
  depends_on "sdl_sound"

  conflicts_with "dosbox", :because => "both install `dosbox` binaries"

  # Otherwise build failure on Moutain Lion (#311)
  needs :cxx11

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

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-sdltest",
                          "--enable-core-inline"

    chmod 0755, "install-sh"
    system "make", "install"
  end

  test do
    assert_match /DOSBox version #{version}/, shell_output("#{bin}/dosbox -version 2>&1", 1)
  end
end
