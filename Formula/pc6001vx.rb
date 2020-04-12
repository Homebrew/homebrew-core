class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "https://eighttails.seesaa.net/"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_3.4.0_src.tar.gz"
  sha256 "4149b4c4a53d002748b7ad6c06a2e0d967ce8a72c6d14e06672df4eb1d968044"
  head "https://github.com/eighttails/PC6001VX.git"

  bottle do
    cellar :any
    sha256 "8743c365fa52afc7d5e2a29092bdcfbd0f7f9fdd5a5209ef575cd8f3e70434cc" => :catalina
    sha256 "86348c8928c6c7e8c09ab6db792f5b0393dac46e87d7ce1e531d369e47ec0ea4" => :mojave
    sha256 "19a0fe720094d0dd8a180ee8adf6d4511d1c51f73765bba1fc6fa61368cb4721" => :high_sierra
    sha256 "9bf00dc16e3c78425109ebe2a17170bb8c0341bb27c3875dc844af815b441b23" => :sierra
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
