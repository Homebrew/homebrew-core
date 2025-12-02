class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/refs/tags/mame0283.tar.gz"
  version "0.283"
  sha256 "cffd615ec2e7a1c708a75ef52593f84b501ff792ebfa553bde0e20ccd5f30d07"
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
    sha256 cellar: :any,                 arm64_tahoe:   "7f3ff4fb008f181faf0c65194d0a0df05e09ea4259a2db0880370795e8f1c16b"
    sha256 cellar: :any,                 arm64_sequoia: "1b3fe3044b83dc11d2a983ec4712b9ae1f06c899a450b6da6a7470875bbbeb58"
    sha256 cellar: :any,                 arm64_sonoma:  "41a621149336614e4d1a36e4d0d8b23c781f06097bd87f839d5c33073615d0c5"
    sha256 cellar: :any,                 sonoma:        "72dbf11799e5ea44b32714e932ee666e6364a202fe009fdc117d9dc8a0ddc995"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39bc2e9b9139f2762b0022e334c148cd74b64d02ac2466f45bcc522906c184c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf3522a664333d8aa47a951c91b0896c4baedacc7b3d0b73bfa1df18160859ea"
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
  depends_on "sdl2"
  depends_on "sqlite"
  depends_on "utf8proc"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "fontconfig"
    depends_on "libx11"
    depends_on "libxi"
    depends_on "mesa"
    depends_on "pulseaudio"
    depends_on "qtbase"
    depends_on "sdl2_ttf"
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
    assert shell_output("#{bin}/mame -help").start_with? "MAME v#{version}"
    system bin/"mame", "-validate"
  end
end
