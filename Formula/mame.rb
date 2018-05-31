class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0198.tar.gz"
  version "0.198"
  sha256 "0c354a5c3d82d46acf2183d6be291364c4454ce6ffdd79cf3397174779cff8fa"
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha256 "4f43dcd7c219f2ccbc4960535f2b040c4d74bea9ad22877522cc6a11235667ec" => :high_sierra
    sha256 "73c5dd0ec21d085455416513a69656ba0b5c9e253785ada9e61a756e3636dbb9" => :sierra
    sha256 "739e00a902e72dd8ea5496b893d3f5a6945d42c9943514f36b1fcac4458010d2" => :el_capitan
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
