class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0194.tar.gz"
  version "0.194"
  sha256 "1faffab72d0d671232a14c73f6e0bec720e086af5c81f8e9c235c314123e761d"
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha256 "e423217b01945f04d3ce67527c4018c544769f46561a949b7cbaf46162b33e0c" => :high_sierra
    sha256 "fe7fbc8e628f7ec1f87b48dc11e4a873a3dfd59be695814f05ae05bc2309faeb" => :sierra
    sha256 "e7e916020e3c4904ad876c8a051aa8e93b0941f9f9dba1d0f4442b3c96f4757b" => :el_capitan
  end

  depends_on :macos => :yosemite
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "sdl2"
  depends_on "jpeg"
  depends_on "flac"
  depends_on "sqlite"
  depends_on "portmidi"
  depends_on "portaudio"
  depends_on "utf8proc"

  # Need C++ compiler and standard library support C++14.
  needs :cxx14

  # jpeg 9 compatibility
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2b7053a/mame/jpeg9.patch"
    sha256 "be8095e1b519f17ac4b9e6208f2d434e47346d8b4a8faf001b68749aac3efd20"
  end

  def install
    inreplace "scripts/src/osd/sdl.lua", "--static", ""
    system "make", "USE_LIBSDL=1",
                   "USE_SYSTEM_LIB_EXPAT=1",
                   "USE_SYSTEM_LIB_ZLIB=1",
                   "USE_SYSTEM_LIB_JPEG=1",
                   "USE_SYSTEM_LIB_FLAC=1",
                   "USE_SYSTEM_LIB_LUA=", # Homebrew's lua@5.3 can't build with MAME yet.
                   "USE_SYSTEM_LIB_SQLITE3=1",
                   "USE_SYSTEM_LIB_PORTMIDI=1",
                   "USE_SYSTEM_LIB_PORTAUDIO=1",
                   "USE_SYSTEM_LIB_UTF8PROC=1"
    bin.install "mame64" => "mame"
    cd "docs" do
      system "make", "text"
      doc.install Dir["build/text/*"]
      system "make", "man"
      man1.install "build/man/MAME.1" => "mame.1"
    end
    pkgshare.install %w[artwork bgfx hash ini keymaps plugins samples uismall.bdf]
  end

  test do
    assert shell_output("#{bin}/mame -help").start_with? "MAME v#{version}"
    system "#{bin}/mame", "-validate"
  end
end
