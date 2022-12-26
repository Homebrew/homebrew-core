class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0250.tar.gz"
  version "0.250"
  sha256 "949ec937b1df50af519f594d690832ca56342983f519b62a4be9c2c0b595d3ad"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git", branch: "master"

  # MAME tags (and filenames) are formatted like `mame0226`, so livecheck will
  # report the version like `0226`. We work around this by matching the link
  # text for the release title, since it contains the properly formatted version
  # (e.g., 0.226).
  livecheck do
    url :stable
    strategy :github_latest
    regex(/>\s*MAME v?(\d+(?:\.\d+)+)/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8408c477904e7f4795342a6255947636a7c5d336d3203f1dc6a3fa2e11bd2593"
    sha256 cellar: :any,                 arm64_monterey: "ba6eadf2c193ad9cd871e82e287db1f384db95a61e7cb7067133cac30df30f06"
    sha256 cellar: :any,                 arm64_big_sur:  "b863d3bbaa6df33d8ff93304a05efd81f33577ecb0fecdc945be3388c8c23260"
    sha256 cellar: :any,                 ventura:        "3050a824d477a3c22d422dddcd8c89c2d079b481511990a4b97c1bad7db9336e"
    sha256 cellar: :any,                 monterey:       "e0fa2715c8738391b12d557bc1b1706024d492a76a0f28904324d106b9e39feb"
    sha256 cellar: :any,                 big_sur:        "ea935f82a56c269cce8c587b1c3bc0686f99a288713739c1d637905d87ffca94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b9d5774f289c93135ebffcc1f6c305209ab3a35d13ec07796b1c28381d079e6"
  end

  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "rapidjson" => :build
  depends_on "sphinx-doc" => :build
  depends_on "flac"
  depends_on "jpeg-turbo"
  # Need C++ compiler and standard library support C++17.
  depends_on macos: :high_sierra
  depends_on "portaudio"
  depends_on "portmidi"
  depends_on "pugixml"
  depends_on "sdl2"
  depends_on "sqlite"
  depends_on "utf8proc"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pulseaudio"
    depends_on "qt@5"
    depends_on "sdl2_ttf"
  end

  fails_with gcc: "5"
  fails_with gcc: "6"

  # Fixes a segfault; will be in the next release.
  # https://github.com/mamedev/mame/issues/10594
  patch do
    url "https://github.com/mamedev/mame/commit/0d93398fb3d48e88209a4f3e07fd389522585ab6.patch?full_index=1"
    sha256 "d4ad64701fac3e6176d69a2052d3bee7eee69061323a57edb815d07d2d2c31d0"
  end

  def install
    # Cut sdl2-config's invalid option.
    inreplace "scripts/src/osd/sdl.lua", "--static", ""

    # Use bundled asio and lua instead of latest version.
    # https://github.com/mamedev/mame/issues/5721
    # https://github.com/mamedev/mame/issues/5349
    system "make", "PYTHON_EXECUTABLE=#{Formula["python@3.11"].opt_bin}/python3.11",
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
    bin.install "mame"
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
