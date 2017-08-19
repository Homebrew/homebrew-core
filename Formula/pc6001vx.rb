class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "http://eighttails.seesaa.net/"
  url "http://eighttails.up.seesaa.net/bin/PC6001VX_2.31.0_src.tar.gz"
  sha256 "88d08329bb94c1de3ad83c75f76409215db8b8d382451a2b683974572475084c"
  head "https://github.com/eighttails/PC6001VX.git"

  bottle do
    cellar :any
    sha256 "62597b7614b42265ec27189f70ab0771f8187e1072061a250d2c155943d60e72" => :sierra
    sha256 "d9747be7031f6711e5776af469f2512b385e6fc88bfa55c331f702adb119eeea" => :el_capitan
    sha256 "5489050ae24f64f057cd68e5afdecd2b1a52c83ac6a709cfb0cdf2e2fc863757" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "qt"
  depends_on "sdl2"
  depends_on "ffmpeg"

  def install
    # Need to explicitly set up include directories
    ENV.append_to_cflags "-I#{Formula["sdl2"].opt_include}"
    ENV.append_to_cflags "-I#{Formula["ffmpeg"].opt_include}"
    # Turn off errors on C++11 build which used for properly linking standard lib
    ENV.append_to_cflags "-Wno-reserved-user-defined-literal"
    # Use libc++ explicitly, otherwise build fails
    ENV.append_to_cflags "-stdlib=libc++" if ENV.compiler == :clang

    # Unix scope in the QT project file includes MacOS, always enabling x11 and x11widgets
    # As a workaround, remove 'macx' from the unix scope in this instance
    inreplace "PC6001VX.pro", "\#Configuration for UNIX variants\nunix {",
                              "\#Configuration for UNIX variants\nunix:!macx {"

    system "qmake", "PREFIX=#{prefix}", "QMAKE_CXXFLAGS=#{ENV.cxxflags}", "CONFIG+=c++11"
    system "make"
    prefix.install "PC6001VX.app"
    bin.write_exec_script "#{prefix}/PC6001VX.app/Contents/MacOS/PC6001VX"
  end
end
