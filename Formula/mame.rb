class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0217.tar.gz"
  version "0.217"
  sha256 "b38873459a781d3b464a0f2c978690e3bdf12bdfee5de5e36fc5b45a32914abe"
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha256 "5f2bf9eab38d5ede4d10f5a9f08e413a9ae1a716141b213693fa3ada09b838d8" => :catalina
    sha256 "9ee6d51ea4bb5d33918ec4aaf5bf755505e8947522c1431afa67589cb6da7671" => :mojave
    sha256 "8b4598fafef423777d389e7e71bfbdebb225915ac7ca9bfb850d17ae9497c944" => :high_sierra
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
