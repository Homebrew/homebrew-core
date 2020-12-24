class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "https://eighttails.seesaa.net/"
  url "https://eighttails.up.seesaa.net/image/PC6001VX_3.6.0_src.tar.gz"
  sha256 "5c67c4d392c399e98c65bcd8518b0cf92551813f70357c41403b100981c1d4e8"
  license "LGPL-2.1"
  head "https://github.com/eighttails/PC6001VX.git"

  bottle do
    cellar :any
    sha256 "3442ef43b00439c58b714acd3e701c57f79608e32fe9e97875979f83c44b1ea0" => :big_sur
    sha256 "041a6c242ad02363b601a7d60e09cecd300cfea7e4f9306c2f88dba49e95f8af" => :catalina
    sha256 "b581bdbe91848b915bf05d4517c821b93ecc7b3e5d5e2256c3f0c5636e9bfb09" => :mojave
    sha256 "d877ea218e51d60d7a48d48c7f27c2260e9c56db4714b9b861330a36ee1462f3" => :high_sierra
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
