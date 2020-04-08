class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0220.tar.gz"
  version "0.220"
  sha256 "8150bc8c60e4704ec222a22a8d4dc89c2de92781d0e52e2820126b4357c36c12"
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha256 "d7117f326fd3b009a92ed2ee11f35ffe8eb076f2f121106756b090fc1bdd93ad" => :catalina
    sha256 "baae3e489fb6025d9d984d1746a76e1e79615e522d6adbb57bc2787a02b15ff8" => :mojave
    sha256 "a02f22733af9275e3c4d1b83dda0fc14a0b1543fc78be646933aa3260c0c44b6" => :high_sierra
  end

  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "pugixml" => :build
  depends_on "rapidjson" => :build
  depends_on "sphinx-doc" => :build
  depends_on "flac"
  depends_on "jpeg"
  depends_on "lua"
  # Need C++ compiler and standard library support C++14.
  # Build failure on Sierra, see:
  # https://github.com/Homebrew/homebrew-core/pull/39388
  depends_on :macos => :high_sierra
  depends_on "portaudio"
  depends_on "portmidi"
  depends_on "sdl2"
  depends_on "sqlite"
  depends_on "utf8proc"

  def install
    inreplace "scripts/src/osd/sdl.lua", "--static", ""

    # Mame's build system genie can't find headers and libraries with version suffix.
    ENV.append "CPPFLAGS", "-I#{Formula["lua"].opt_include}/lua"
    ENV.append "CPPFLAGS", "-I#{Formula["pugixml"].opt_include}/pugixml-1.9"
    ENV.append "LDFLAGS", "-L#{Formula["pugixml"].opt_lib}/pugixml-1.9"

    system "make", "USE_LIBSDL=1",
                   "USE_SYSTEM_LIB_EXPAT=1",
                   "USE_SYSTEM_LIB_ZLIB=1",
                   "USE_SYSTEM_LIB_FLAC=1",
                   "USE_SYSTEM_LIB_GLM=1",
                   "USE_SYSTEM_LIB_JPEG=1",
                   "USE_SYSTEM_LIB_LUA=1",
                   "USE_SYSTEM_LIB_PORTMIDI=1",
                   "USE_SYSTEM_LIB_PORTAUDIO=1",
                   "USE_SYSTEM_LIB_PUGIXML=1",
                   "USE_SYSTEM_LIB_RAPIDJSON=1",
                   "USE_SYSTEM_LIB_SQLITE3=1",
                   "USE_SYSTEM_LIB_UTF8PROC=1"
    bin.install "mame64" => "mame"
    cd "docs" do
      # We don't convert SVG files into PDF files, don't load the related extensions.
      inreplace "source/conf.py", "'sphinxcontrib.rsvgconverter'", ""
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
