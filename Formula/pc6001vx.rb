class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "https://eighttails.seesaa.net/"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_3.7.0_src.tar.gz"
  sha256 "8a735fa6769b1a268fc64c0ed92d7e27c5990b120f53ad50be255024db35b2b8"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f2f336642c7a262778f1488c7393141001d44f9926561317f718dbf21e684000"
    sha256 cellar: :any, big_sur:       "89f9afe028baa7e2ff9bac2791f5d0c59186bafe5de3eb90817f229157ab35ce"
    sha256 cellar: :any, catalina:      "38f1c392ed9cb5042619b663c8ef659f64ee3d8004beac5966af534cf3a977f8"
    sha256 cellar: :any, mojave:        "12b257f629ecda8063fdede742c95ac88bf0adac8b99923cda54acacfc83136b"
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
