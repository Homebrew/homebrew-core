class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "https://eighttails.seesaa.net/"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_3.6.1_src.tar.gz"
  sha256 "9bd3d7eb02c6535c98539bb0c3f5e6146b945ff021ec1e221d6b4feb18ac3cf3"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git"

  bottle do
    cellar :any
    sha256 "8b5a64b028a8534033f6ea1b6101aeb1599bb497a8f2fd55ddff718e020a19a3" => :big_sur
    sha256 "44404d7b3752cecfa0a5f6ddca04fa30f8f8dd10fb3c262cd9d2e69c5cb3958c" => :arm64_big_sur
    sha256 "80de7e25b021a3913630a7c56ed5e5d5b56313806ab837dbc7111b8a6561e115" => :catalina
    sha256 "f8ed76c4f02f54d813f476a83ea4500e4c79d72105283a55cd94eaf47eb6d692" => :mojave
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
