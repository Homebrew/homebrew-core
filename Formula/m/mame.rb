class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/refs/tags/mame0287.tar.gz"
  version "0.287"
  sha256 "85f5e91b0f31f0c398834b888cd5a83dc2466569250069cb6e3712158d015f44"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git", branch: "master"

  # MAME tags (and filenames) are formatted like `mame0226`, so livecheck will
  # report the version like `0226`. We work around this by matching the link
  # text for the release title, since it contains the properly formatted version
  # (e.g., 0.226).
  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ecdc250d81d7523f9927d28bdfd7b84988b16ea499a45919b4d3d13e367032a0"
    sha256 cellar: :any,                 arm64_sequoia: "405f42dc64dc4418ada7c9ff248fc67fcef6fd44209eea382e63cd3aee48b0d0"
    sha256 cellar: :any,                 arm64_sonoma:  "d0c78cac774576693c1b530d570105cfb2cf8c7e9039fc1863f9a3cc2bba5204"
    sha256 cellar: :any,                 sonoma:        "0057901b5e7a9030852c8767b64ca05af1d44c297c2ddfd2bd70ffb3d8d12a80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db3711d306bf7d875720ceaf40c09a10024f28ad1bb7b0dc50644be7d006217a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26c3825cfb6b5fcae6f6ca8ab006cafd753511cb5652bd62a65f3cd6fa7266e8"
  end

  # `asio`` v1.30.1 is bundled and it is not compatible with the `asio` formula
  # Unless mame is updated to use the newer one, let's use the bundled one.
  depends_on "glm" => :build
  depends_on "pkgconf" => :build
  depends_on "rapidjson" => :build
  depends_on "sphinx-doc" => :build
  depends_on "flac"
  depends_on "jpeg-turbo"
  depends_on "portaudio"
  depends_on "portmidi"
  depends_on "pugixml"
  depends_on "sdl3"
  depends_on "sqlite"
  depends_on "utf8proc"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "expat"

  on_linux do
    depends_on "fontconfig"
    depends_on "libx11"
    depends_on "libxi"
    depends_on "mesa"
    depends_on "pulseaudio"
    depends_on "qtbase"
    depends_on "sdl3_ttf"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["QT_HOME"] = Formula["qtbase"].opt_prefix if OS.linux?

    # Cut sdl2-config's invalid option.
    inreplace "scripts/src/osd/sdl.lua", "--static", ""

    # Use bundled lua instead of latest version.
    # https://github.com/mamedev/mame/issues/5349
    system "make", "PYTHON_EXECUTABLE=#{which("python3")}",
                   "USE_LIBSDL=1",
                   "USE_SYSTEM_LIB_EXPAT=1",
                   "USE_SYSTEM_LIB_ZLIB=1",
                   "USE_SYSTEM_LIB_ASIO=0", # Use bundled one for compatibility
                   "USE_SYSTEM_LIB_FLAC=1",
                   "USE_SYSTEM_LIB_GLM=1",
                   "USE_SYSTEM_LIB_JPEG=1",
                   "USE_SYSTEM_LIB_PORTAUDIO=1",
                   "USE_SYSTEM_LIB_PORTMIDI=1",
                   "USE_SYSTEM_LIB_PUGIXML=1",
                   "USE_SYSTEM_LIB_RAPIDJSON=1",
                   "USE_SYSTEM_LIB_SQLITE3=1",
                   "USE_SYSTEM_LIB_UTF8PROC=1",
                   "USE_SYSTEM_LIB_ZSTD=1",
                   "OSD=sdl3",
                   "VERBOSE=1"
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
    assert_match "MAME v#{version}", shell_output("#{bin}/mame -help")
    system bin/"mame", "-validate"
  end
end
