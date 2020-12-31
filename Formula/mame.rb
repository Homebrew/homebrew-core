class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  # NOTE: Please keep these values in sync with rom-tools.rb when updating.
  url "https://github.com/mamedev/mame/archive/mame0227.tar.gz"
  version "0.227"
  sha256 "95dbce00a4f05a35f66ef966fe9efad1e4e78ce62e0eba3f7031dfa6737829a5"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git"

  # MAME tags (and filenames) are formatted like `mame0226`, so livecheck will
  # report the version like `0226`. We work around this by matching the link
  # text for the release title, since it contains the properly formatted version
  # (e.g., 0.226).
  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{release-header.*?/releases/tag/mame[._-]?\d+(?:\.\d+)*["' >]>MAME v?(\d+(?:\.\d+)+)}im)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "df514e97b41c36a65fb3d0729f8e927887cd9d1f7b3f23a189e4430a1e48bb76" => :big_sur
    sha256 "9bc14fa247f653226bcdc771ad60ba70d2dc5e19b3386b547cf9b02c6f760615" => :catalina
    sha256 "ca698bbefa83ddc6be99d0a471fe7f6303b35a6c757bb5b6b73a70acf8281c3f" => :mojave
  end

  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "pugixml" => :build
  depends_on "python@3.9" => :build
  depends_on "rapidjson" => :build
  depends_on "sphinx-doc" => :build
  depends_on "flac"
  depends_on "jpeg"
  # Need C++ compiler and standard library support C++17.
  depends_on macos: :high_sierra
  depends_on "portaudio"
  depends_on "portmidi"
  depends_on "sdl2"
  depends_on "sqlite"
  depends_on "utf8proc"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    # Cut sdl2-config's invalid option.
    inreplace "scripts/src/osd/sdl.lua", "--static", ""

    # Use bundled asio and lua instead of latest version.
    # https://github.com/mamedev/mame/issues/5721
    # https://github.com/mamedev/mame/issues/5349
    system "make", "PYTHON_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3",
                   "USE_LIBSDL=1",
                   "USE_SYSTEM_LIB_EXPAT=1",
                   "USE_SYSTEM_LIB_ZLIB=1",
                   "USE_SYSTEM_LIB_ASIO=",
                   "USE_SYSTEM_LIB_LUA=",
                   "USE_SYSTEM_LIB_FLAC=1",
                   "USE_SYSTEM_LIB_GLM=1",
                   "USE_SYSTEM_LIB_JPEG=1",
                   "USE_SYSTEM_LIB_PORTAUDIO=1",
                   "USE_SYSTEM_LIB_PORTMIDI=1",
                   "USE_SYSTEM_LIB_PUGIXML=1",
                   "USE_SYSTEM_LIB_RAPIDJSON=1",
                   "USE_SYSTEM_LIB_SQLITE3=1",
                   "USE_SYSTEM_LIB_UTF8PROC=1"
    bin.install "mame64" => "mame"
    cd "docs" do
      # We don't convert SVG files into PDF files, don't load the related extensions.
      inreplace "source/conf.py", "'sphinxcontrib.rsvgconverter',", ""
      system "make", "text"
      doc.install Dir["build/text/*"]
      system "make", "man"
      man1.install "build/man/MAME.1" => "mame.1"
    end
    pkgshare.install %w[artwork bgfx hash ini keymaps language plugins samples uismall.bdf]
  end

  test do
    assert shell_output("#{bin}/mame -help").start_with? "MAME v#{version}"
    system "#{bin}/mame", "-validate"
  end
end
