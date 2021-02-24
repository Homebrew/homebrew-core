class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  # NOTE: Please keep these values in sync with rom-tools.rb when updating.
  url "https://github.com/mamedev/mame/archive/mame0228.tar.gz"
  version "0.228"
  sha256 "1d8e6f20491492f8b15892ff958f9b067c48eb90cc2fc974b08bde297e657244"
  license "GPL-2.0-or-later"
  head "https://github.com/mamedev/mame.git"

  # MAME tags (and filenames) are formatted like `mame0226`, so livecheck will
  # report the version like `0226`. We work around this by matching the link
  # text for the release title, since it contains the properly formatted version
  # (e.g., 0.226).
  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{release-header.*?/releases/tag/mame[._-]?\d+(?:\.\d+)*["' >]>MAME v?(\d+(?:\.\d+)+)}im)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e691df3aecfbe3bd954bb67e9f77274a3294781d4c4b8b0db5c867fc1f5e88a3"
    sha256 cellar: :any, big_sur:       "a4a2c392a16ddf14ab1890c56a51a5c99f33438bd0af9396ff3b51cf5b65e6f0"
    sha256 cellar: :any, catalina:      "60bdbeb0fe470d57fbfbce0ec579b7c6a399506445137d8fdced4bb961d6e3af"
    sha256 cellar: :any, mojave:        "997ec943f87a8026bcd7df415aaf48bfc56b5a9668093f9398e1f48dea4c165b"
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
    bin.install "mame64" => "mame"
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
