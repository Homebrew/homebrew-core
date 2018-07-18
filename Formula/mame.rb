class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0199.tar.gz"
  version "0.199"
  sha256 "cf4511d6c893e699fd5bc510133aee75c852942321e1c668c9d5802229bec116"
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha256 "61f48dddec9bc5c840a62fb1922d55c1528840bc50717b917fbbdc9a2b72adaa" => :high_sierra
    sha256 "fe65706b184a13af844ea0036186880cd85c192f32b448b03b31ab17668ed187" => :sierra
    sha256 "77390e4d5a56ee6db55bc26bb633ec0b4540f3227393bafde9628be68a0313ef" => :el_capitan
  end

  depends_on :macos => :yosemite
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "sdl2"
  depends_on "jpeg"
  depends_on "flac"
  depends_on "lua"
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
