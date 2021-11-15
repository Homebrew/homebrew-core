class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0237.tar.gz"
  version "0.237"
  sha256 "92dc0f38ec1a2412c6b9c1403cae610bc13e1d21b4e647ab290d41215a940cae"
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
    sha256 cellar: :any,                 arm64_monterey: "bcbbdcf0ed0b561780635a8d6bc5d98c7842e19a0bef5dc1770c4fdc40fead2a"
    sha256 cellar: :any,                 arm64_big_sur:  "ae69e6360a98090ac9a88b743d20dfccdaeca73819217ad77b9ac58219b6c147"
    sha256 cellar: :any,                 monterey:       "908a08c5a1b8e7990b7597a1efc27527cfe327195c95d1c6630716d2fb862adb"
    sha256 cellar: :any,                 big_sur:        "6e8c710fef34cb1c767d77d4b5a01c8ab2f546c55b2cf11ce42fd6775e39cac8"
    sha256 cellar: :any,                 catalina:       "acd6b16a2b279662173b45378172b6dfd4c6d9eca59b1ab04bd57b5d37a68e47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0d818ecc96a34cb778bac9b6fa3a7736ffbbc8c4e483a62d49476ca3f113ebe"
  end

  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "rapidjson" => :build
  depends_on "sphinx-doc" => :build
  depends_on "flac"
  depends_on "jpeg"
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
    depends_on "gcc" # for C++17
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
