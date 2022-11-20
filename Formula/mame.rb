class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0248.tar.gz"
  version "0.248"
  sha256 "7eef82527a4b66647e02625948d42e3502f13183192ea48e6fc2786d6f9222a0"
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
    sha256 cellar: :any,                 arm64_ventura:  "19f62fc2a4a981513d1c3a7c424dd5126bbe232f17942517400ce43814a4746a"
    sha256 cellar: :any,                 arm64_monterey: "2eac1c7f058557d5a836f0ec456a6795c90f42ad65e8047ada99fba93864891e"
    sha256 cellar: :any,                 arm64_big_sur:  "175f5ce71650fff874742963204d5e3bb0c9a27ecc765ba7295008ca9a327d82"
    sha256 cellar: :any,                 ventura:        "f07c273321560ca1a262c8775d230e2fef65d06027944e4c3dd5ff783d899fce"
    sha256 cellar: :any,                 monterey:       "5bb5d663495e95bfd50673efdd62317eb19837990068452fe07b359e40efff24"
    sha256 cellar: :any,                 big_sur:        "a086ac658368380fe1868be396b0df058643a96c89f5ada65a936dcc21699eb1"
    sha256 cellar: :any,                 catalina:       "dbb80839f064f33ac41e41058a8af0664a1e0023f98b7dff8ed9792b6745e1f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ae9e4e0a77951af89459eee3185a62d2cd80e73ded027c9551b38415f5fadbb"
  end

  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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

  def install
    # Cut sdl2-config's invalid option.
    inreplace "scripts/src/osd/sdl.lua", "--static", ""

    # Use bundled asio and lua instead of latest version.
    # https://github.com/mamedev/mame/issues/5721
    # https://github.com/mamedev/mame/issues/5349
    system "make", "PYTHON_EXECUTABLE=#{Formula["python@3.10"].opt_bin}/python3.10",
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
