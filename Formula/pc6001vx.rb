class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "http://eighttails.seesaa.net/"
  url "http://eighttails.up.seesaa.net/bin/PC6001VX_2.30.0_src.tar.gz"
  sha256 "51347ba79b05c66fe029cfc430ba2a4661b61d25ec3b03bc405b52a2fac97021"
  revision 1
  head "https://github.com/eighttails/PC6001VX.git"

  bottle do
    cellar :any
    sha256 "42beba7cb2d6d32b89f967a9e834bd833b4ad5bddb2fed32dd00bf5447dabb66" => :sierra
    sha256 "514347a708086aa5d590ebedf7ea0682195546ccf21e9d81082e46b3448c76aa" => :el_capitan
    sha256 "8bdc3a0e6e8c5b32f476a87c5057269de0a179ee3eb8e07d10f3524584f4708f" => :yosemite
  end

  depends_on "qt@5.7"
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
    system "qmake", "PREFIX=#{prefix}", "QMAKE_CXXFLAGS=#{ENV.cxxflags}", "CONFIG+=c++11"
    system "make"
    prefix.install "PC6001VX.app"
    bin.write_exec_script "#{prefix}/PC6001VX.app/Contents/MacOS/PC6001VX"
  end
end
