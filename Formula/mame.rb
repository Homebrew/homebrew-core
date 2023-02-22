class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0252.tar.gz"
  version "0.252"
  sha256 "9d6365fed1c5f6a7a854d5489df4c70300d01d2aabf6764b0e2476b59babc13e"
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
    sha256 cellar: :any,                 arm64_ventura:  "3a0686b3a15e5e9585b5db8c41b0c077fd9ce6a49a83210a0f57bac6ded09c47"
    sha256 cellar: :any,                 arm64_monterey: "c78e853b273fc3bf916e3750ff3d5034e87ca0cab6bf09f520bad73bf3a07cda"
    sha256 cellar: :any,                 arm64_big_sur:  "261d390dbee11b6c36036eaeb011b33b43550af5210a1b0379939e7d14efe35c"
    sha256 cellar: :any,                 ventura:        "f0abca64a83844342614d85a36e2b4cf1352660cb879c821d2635127f923ce8d"
    sha256 cellar: :any,                 monterey:       "5f79eeeb386cf2ae98f032ec53ffc2c16a40e5966bd4e52fef64e5c955facdf4"
    sha256 cellar: :any,                 big_sur:        "97342443bcd9a0872d565b12724a150ed3155f65d1c229a39bc9a3ffa15c9a9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34cdafbd9f9e91f9c6a8696afdd7daee3374072cd18513afb9fcebbb99d1093d"
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
