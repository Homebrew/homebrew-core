class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0243.tar.gz"
  version "0.243"
  sha256 "8cddb7d6cee5d736d1ce7ef2022e2d09b5c61bea02b5df7e369010a47a5d2133"
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
    sha256 cellar: :any,                 arm64_monterey: "0f00c10dce700d9487a8161d27cec9e02115e77afdb5616a2e0fb5e607fadc7d"
    sha256 cellar: :any,                 arm64_big_sur:  "409a6012647d065200b67c245a4d4492f97681df124dfd1677c373d40900d25b"
    sha256 cellar: :any,                 monterey:       "af2172e64d860097b919d54f1fe8c6c1d589958cd3d41496bb44b1346016211d"
    sha256 cellar: :any,                 big_sur:        "585abbb5d556ee6fd279762262fd98b2d064c7d10142c66d36579f48b5b18e61"
    sha256 cellar: :any,                 catalina:       "dd6a388ce8c55608a38879dc6cdf7a181df9ebb0c7ef1a6656517f5fc0b4ee2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd9d3af950756be1bfff79d4299d8dd840d4a6c1bc82e21de081bc2d859a73ad"
  end

  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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
    system "make", "PYTHON_EXECUTABLE=#{Formula["python@3.10"].opt_bin}/python3",
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
