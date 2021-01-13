class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "https://eighttails.seesaa.net/"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_3.6.1_src.tar.gz"
  sha256 "9bd3d7eb02c6535c98539bb0c3f5e6146b945ff021ec1e221d6b4feb18ac3cf3"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "06bf7debd67d4f1b4165b35b222f48fa19eac46d6b73bcae04af093a61efcab5" => :big_sur
    sha256 "6fbc717e8c3726eda2135bf5d881dbfd110c26a11b4fc4c09a4063663f437d8b" => :arm64_big_sur
    sha256 "c53cf5ef699b779e5160200f901eae55ff108ab0ab9cf489a422a3d239ed1710" => :catalina
    sha256 "d7665cfb82d6a249a3b8dea0cdef20e2f08a7ca0a39fccbc11e1ad3ac2f2e043" => :mojave
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
