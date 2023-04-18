class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0253.tar.gz"
  version "0.253"
  sha256 "52065a1ae0db365a9aa35d62bafb226edc546ad993d6c75327e166596f25e4e4"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git", branch: "master"

  # MAME tags (and filenames) are formatted like `mame0226`, so livecheck will
  # report the version like `0226`. We work around this by matching the link
  # text for the release title, since it contains the properly formatted version
  # (e.g., 0.226).
  livecheck do
    url :stable
    regex(/>\s*MAME v?(\d+(?:\.\d+)+)/im)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "146606e72196cf8f0dc17a5ec59b477efb35f793724b72dee8d96a5f3a916e89"
    sha256 cellar: :any,                 arm64_monterey: "c4bb693e6aa271aa2e6f508c7c5105edb442d8b5f6324a91dab895dad5610ba1"
    sha256 cellar: :any,                 arm64_big_sur:  "de2b43be056be62b1e24eff4596d920e66c280ad425971060a56dbefd105cfbf"
    sha256 cellar: :any,                 ventura:        "2de715bcb0af1f2a8c069ffdcabdbf7e5f2b1592df5ce8ac551882752d5980cd"
    sha256 cellar: :any,                 monterey:       "b2063e09501c8c37c9a517d47962cf339d73d3d0e0583d790c489a166efce327"
    sha256 cellar: :any,                 big_sur:        "7f98d77d112a4160d4dff2a4442382dd6efae5fe646bff3dd577ff8fc8ee2985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d859b6a8cfee2a6f76d9ea439cd56ab6b4f5e2a59f4b938f5937d5d1083f2be8"
  end

  depends_on "asio" => :build
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

    # Use bundled lua instead of latest version.
    # https://github.com/mamedev/mame/issues/5349
    system "make", "PYTHON_EXECUTABLE=#{Formula["python@3.11"].opt_bin}/python3.11",
                   "USE_LIBSDL=1",
                   "USE_SYSTEM_LIB_EXPAT=1",
                   "USE_SYSTEM_LIB_ZLIB=1",
                   "USE_SYSTEM_LIB_ASIO=1",
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
