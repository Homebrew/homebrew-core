class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/refs/tags/mame0282.tar.gz"
  version "0.282"
  sha256 "730d6264f0851de521ca03b71f8556f2b31b8f06d415b52d1ba31aafff9f6c3f"
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
    sha256 cellar: :any,                 arm64_tahoe:   "b46f4ea173e8a5971c374ca43cd6674a4dc6ddda29cd925bda1c0932462cc19c"
    sha256 cellar: :any,                 arm64_sequoia: "5e76cd5b96fd527b4dc5afdc0f58410f57f9acfd3c8439f455ada35da1a837dd"
    sha256 cellar: :any,                 arm64_sonoma:  "ae59bf8a458d3b8fe52e99f9ed30dd54c5bb56c89328f3bf0c3f9ddf62415a52"
    sha256 cellar: :any,                 sonoma:        "add501c18cdda4bd6d03d376f646582e3f1d27ff6e131d7363c818c5e223c82b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d893ad3d2b0fb01cce4b5bbbeb76958387807de848b56ccfea6e8f5dd17483c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea87076d479be46c8677214cfc7a65b4c65dc69e1daf7df01305216a713e57bb"
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
