class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "http://eighttails.seesaa.net/"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_3.1.3_src.tar.gz"
  sha256 "0f7644d91759771639216a722f24e1a9bebc0f6bbdd8ea55807b2b0df87ccb73"
  head "https://github.com/eighttails/PC6001VX.git"

  bottle do
    cellar :any
    sha256 "7a3d0b9bd2e67dba50d39b1a9a9bb697824bbba8e811c9df27fe5623bcd4dc41" => :mojave
    sha256 "7d554aec28e66b88025e6438b2a776c000bebf470a5b04c04d551ad0fcec2ae7" => :high_sierra
    sha256 "ce1b8bb4d6271a5c5bfdcc3d3c2f23131976d17ed426cee1e957cd220e26a697" => :sierra
    sha256 "0c0066a5765c75071974af3dcbeabc13c440e4ec90c803e0f81120a42909ff42" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "qt"
  depends_on "sdl2"

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
