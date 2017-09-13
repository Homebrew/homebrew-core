class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0189.tar.gz"
  version "0.189"
  sha256 "0550d5a1403e4dc4ccab2054468ebe215fd85a43076e02b1aadcacfceb577ddf"
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha256 "059e81a3331188c64173136f2b1080cb429c87e5f7d711fbcdb335792c5c2f58" => :sierra
    sha256 "b067e5a453bde59c4fb65444dad06946d096fa39ed7ee20de82450e541c1db38" => :el_capitan
    sha256 "6c80fcef18c2228972615510a51f5fce99d3825b206e304437fc53a1e20dc351" => :yosemite
  end

  depends_on :macos => :yosemite
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "sdl2"
  depends_on "expat"
  depends_on "jpeg"
  depends_on "flac"
  depends_on "sqlite"
  depends_on "portmidi"
  depends_on "portaudio"
  depends_on "utf8proc"

  # Needs compiler and library support C++14.
  needs :cxx14

  # jpeg 9 compatibility
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2b7053a/mame/jpeg9.patch"
    sha256 "be8095e1b519f17ac4b9e6208f2d434e47346d8b4a8faf001b68749aac3efd20"
  end

  # Patch for Xcode 9: https://github.com/mamedev/mame/issues/2598
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/7ab58e7967/mame/xcode9.patch"
      sha256 "2d7d0ffa9adbee780ce584403f4c2a7386b5edb097321efafc1778fc0200573d"
    end
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
