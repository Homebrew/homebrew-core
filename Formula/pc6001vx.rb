class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "https://eighttails.seesaa.net/"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_3.5.3_src.tar.gz"
  sha256 "7473055dbcd9c288c0d303a0dbead82a6e4e0d9c351785284b96a2a28a733d70"
  license "LGPL-2.1"
  head "https://github.com/eighttails/PC6001VX.git"

  bottle do
    cellar :any
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
