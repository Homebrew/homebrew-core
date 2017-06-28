class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0187.tar.gz"
  version "0.187"
  sha256 "5ac6950158ba6f550b3c5f19434752e837f17edf0d83c41ab07d0f02cca787b0"
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha256 "5e363afe9682a8e991cb44555f80087ce562328ab1e1e68553dbdbb25ab9c902" => :sierra
    sha256 "979570f8910f82cac14fe04d9b4c94b9499787acd6a276a9d0fe32a365c3ccfb" => :el_capitan
    sha256 "73009de90057ee9c39cd38bf9cf7067ffa3b83e894a7cbe185b4685985b95fb1" => :yosemite
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
