class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "http://eighttails.seesaa.net/"
  url "http://eighttails.up.seesaa.net/bin/PC6001VX_3.0.0_src.tar.gz"
  sha256 "ab8915407833d95f4b38e9d86b14f548c9f6431eaa324eb046b3ef4fc95a8f51"
  head "https://github.com/eighttails/PC6001VX.git"

  bottle do
    cellar :any
    sha256 "8989ed42d20a7401572d8ccb4b5174a871fc443bfeec6110149f6eb950a1a207" => :high_sierra
    sha256 "3680e8f30c439451e08b43bdf75c05641314466042b81f0a226b69eed7176751" => :sierra
    sha256 "256f04c23cf1742c5534910281e3e82c518705fe02d3d9bf8a4d5987073edd9a" => :el_capitan
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

    system "qmake", "PREFIX=#{prefix}", "QMAKE_CXXFLAGS=#{ENV.cxxflags}", "CONFIG+=c++11"
    system "make"
    prefix.install "PC6001VX.app"
    bin.write_exec_script "#{prefix}/PC6001VX.app/Contents/MacOS/PC6001VX"
  end
end
