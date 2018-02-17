class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "http://eighttails.seesaa.net/"
  url "http://eighttails.up.seesaa.net/bin/PC6001VX_2.32.0_src.tar.gz"
  sha256 "0626ccac67f9813103c96823f6a58c187a8e7eb5a5b1a90945ff6e0807fd875b"
  head "https://github.com/eighttails/PC6001VX.git"

  bottle do
    cellar :any
    sha256 "4a4d77fa8ede4197f2b28c7d065e59e119cd99f515867fdc9540ebe3bed01d8d" => :high_sierra
    sha256 "83f39f11e2a2f169c35c009df6951120eac59cc6320b4dc05b553b768c9eb9c4" => :sierra
    sha256 "1c480ada4c50ee19cf41dafa981fe57b019ed0eddca3ddb56d3157154ad5ee93" => :el_capitan
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
