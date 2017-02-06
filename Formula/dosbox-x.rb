class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "http://dosbox-x.com/"
  head "https://github.com/joncampbell123/dosbox-x.git"

  stable do
    url "https://github.com/joncampbell123/dosbox-x/archive/v0.801.tar.gz"
    sha256 "40f94cdcc5c9a374c522de7eb2c2288eaa8c6de85d0bd6a730f48bd5d84a89f9"
  end
  bottle do
    cellar :any
    revision 1
    sha256 "e87541a7f22a8cea8d8888f4b2321186279ad88d1d0455156946b08ac2be423d" => :el_capitan
    sha256 "d096d2ee803fc3c8e573f8cdf4f8659ea6cbe1af12b643d496b62db0b2c98b0c" => :yosemite
    sha256 "6c72c099d9601e8061c3aca6df90afccf87f590606f55e9b0fa289678d6ee445" => :mavericks
  end

  depends_on "sdl"
  depends_on "sdl_net"
  depends_on "sdl_sound" => ["--with-libogg", "--with-libvorbis"]
  depends_on "libpng"
  depends_on "fluid-synth"

  # Otherwise build failure on Moutain Lion (#311)
  needs :cxx11

  conflicts_with "dosbox", :because => "both install `dosbox` binaries"

  def install
    ENV.cxx11

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
