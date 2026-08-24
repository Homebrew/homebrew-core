class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/refs/tags/mame0289.tar.gz"
  version "0.289"
  sha256 "0929cc749afabcef892900e10dd90bd8b05f94a7dde8f367ac6a5d2082589f84"
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
    sha256 cellar: :any, arm64_tahoe:   "8b15aa506cb2926763edbdb69833e7b308e3ba4904afa0ca32cd966cc8860ba4"
    sha256 cellar: :any, arm64_sequoia: "d16d30d95cba83260dd91600f6b7b37d708d36f182a338e9d4994e273f222bc7"
    sha256 cellar: :any, arm64_sonoma:  "38df7c25402a221fda81c09d53ce5a96110ec67830db14f8749c90e567b51f4f"
    sha256 cellar: :any, sonoma:        "4afdae543ae6fdccb34f47dbcadf8b4ca758d299e941efb8c07b5f5719aa8ae0"
    sha256 cellar: :any, arm64_linux:   "757ba5c64d0fc470d272f9a197444ff8c26626660b0795e5b038699635f48869"
    sha256 cellar: :any, x86_64_linux:  "2be8a7b5e3dac0090541c7f110caea8135dbf65d19dd25969987704868a2a683"
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

    on_arm do
      # System `ld` fails to insert range-extension stubs: R_AARCH64_CALL26 relocation truncated to fit
      depends_on "binutils" => :build
    end
  end

  def install
    ENV["QT_HOME"] = formula_opt_prefix("qtbase") if OS.linux?

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
