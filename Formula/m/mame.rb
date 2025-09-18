class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/refs/tags/mame0280.tar.gz"
  version "0.280"
  sha256 "ffebdf23f2e3b3628e86e1bf9a217343c7c0462b94e3a201f20e3ebc848bd578"
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
    sha256 cellar: :any,                 arm64_tahoe:   "f5baa70356084df09f45ffe741e5fec0c24b0917e8a3607be2b682c50348094f"
    sha256 cellar: :any,                 arm64_sequoia: "08fc202c2085f4e79c04ad305cee47e9787b91bfa030fdb47cf2033367eded4c"
    sha256 cellar: :any,                 arm64_sonoma:  "31378d82fc62af92329b8b89c7f8dabdad9109792bf822c5128964c0b8f61c01"
    sha256 cellar: :any,                 arm64_ventura: "56d4dede2b76d9ea4c5aaedb4c9bee0cc28fd5551c3f8b1fd0fc7514e468aaa5"
    sha256 cellar: :any,                 sonoma:        "f375eb8e094494bcc7f85a21f44874f0c54bbb422e6a1c276093f092620caffd"
    sha256 cellar: :any,                 ventura:       "a464576778e3a18bd048bf7ae7190b90b4e0393ce866c6a0160320f27b2f8fc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a367ff761af5e23bbb37b339d9fde7031806cb3d271f23c694e1c4068dd0a7a8"
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
    depends_on "qt"
    depends_on "sdl2_ttf"
  end

  def install
    ENV["QT_HOME"] = Formula["qt"].opt_prefix if OS.linux?

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
