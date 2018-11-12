class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0203.tar.gz"
  version "0.203"
  sha256 "e17aa95f8897217d433e44e2f4b75ac7b5e13184549b7d14098d52652b7eb49a"
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha256 "359acb1e76b98ffe5a0fcef14143c74bd92e2be6045e421862d296f5612b6a3c" => :mojave
    sha256 "3e559b8a56424fb15ca88aa2d5596035c491e9dc3b3eab8e1df83a871bce3ccc" => :high_sierra
    sha256 "6bfe9f96ba4faf518281c91ec325f2a7373453a260a91696598db8f0564375e6" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "flac"
  depends_on "jpeg"
  depends_on "lua"
  depends_on :macos => :yosemite
  depends_on "portaudio"
  depends_on "portmidi"
  depends_on "sdl2"
  depends_on "sqlite"
  depends_on "utf8proc"

  # Need C++ compiler and standard library support C++14.
  needs :cxx14

  def install
    inreplace "scripts/src/osd/sdl.lua", "--static", ""

    # 3rdparty/sol2/sol/compatibility/version.hpp:30:10
    # fatal error: 'lua.hpp' file not found
    ENV.append "CPPFLAGS", "-I#{Formula["lua"].opt_include}/lua"

    system "make", "USE_LIBSDL=1",
                   "USE_SYSTEM_LIB_EXPAT=1",
                   "USE_SYSTEM_LIB_ZLIB=1",
                   "USE_SYSTEM_LIB_JPEG=1",
                   "USE_SYSTEM_LIB_FLAC=1",
                   "USE_SYSTEM_LIB_LUA=1",
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
