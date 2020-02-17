class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.8.1.tar.gz"
  sha256 "df136ea50c9cca380ab93e00fd8d87811e41a49a804c5b0e018babef0c490f13"
  head "https://github.com/mgba-emu/mgba.git"

  bottle do
    sha256 "76a98e9cdce005a188ad3cdfb15dcb21a9a568f1070a0c6f46dcfc72113976b2" => :catalina
    sha256 "bdd91d0a50970f0b512f33291bda00e5e51fb4077ad53e8bbf35f8ead456623c" => :mojave
    sha256 "925f36a875f112795ce8ffbcc17b534eb9fb1a5e20ba8a8bbbfb23b4ea90b105" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "imagemagick"
  depends_on "libepoxy"
  depends_on "libpng"
  depends_on "libzip"
  depends_on "qt"
  depends_on "sdl2"

  def install
    # Fix "error: 'future<void>' is unavailable: introduced in macOS 10.8"
    # Reported 11 Dec 2017 https://github.com/mgba-emu/mgba/issues/944
    if MacOS.version <= :el_capitan
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    end

    # Install .app bundle into prefix, not prefix/Applications
    inreplace "src/platform/qt/CMakeLists.txt", "Applications", "."

    system "cmake", ".", *std_cmake_args
    system "make", "install"

    # Replace SDL frontend binary with a script for running Qt frontend
    # -DBUILD_SDL=OFF would be easier, but disable joystick support in Qt frontend
    rm bin/"mgba"
    bin.write_exec_script "#{prefix}/mGBA.app/Contents/MacOS/mGBA"
  end

  test do
    system "#{bin}/mGBA", "-h"
  end
end
