class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/refs/tags/mame0270.tar.gz"
  version "0.270"
  sha256 "0364b670478883902c2bc618908192b0590235b47fbe073fcac2d13b82541437"
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

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "655b0ee403eb625726129c3a91992926b5b1a24435f3e732ac4cac9ca4331320"
    sha256 cellar: :any,                 arm64_sonoma:  "9b5b74a72460aee2691ffc904bf542d2888cb9ac082a0c56bf290c3e1fd5375d"
    sha256 cellar: :any,                 arm64_ventura: "c338a60149366261430fa1bf6a710cebf65e69ea94ceb67ba6e99657a6d3ddb8"
    sha256 cellar: :any,                 sonoma:        "8ca7940a3f89c2b7d0c18738a34dc716ac38ca2d67cdb41eca29e2d58fc81e83"
    sha256 cellar: :any,                 ventura:       "28461f747b1ff834336dd4f41f2b6e894aeec8baa68bfc2ce9085bcc8a882ae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2c042479a6f4cf61b2a2687955d3081423878b77208bd19c5272cd477504196"
  end

  depends_on "asio" => :build
  depends_on "glm" => :build
  depends_on "pkg-config" => :build
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

  # Support alternate Qt libexec directories
  # PR ref: https://github.com/mamedev/mame/pull/12870
  patch do
    url "https://github.com/mamedev/mame/commit/f1604dbe7e51f519bb98cf4c52c8b0e41184384b.patch?full_index=1"
    sha256 "42204cbf23c6a20a8b2dba515ce50e119870b5037fe224da45c53782170fb1df"
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
                   "USE_SYSTEM_LIB_ASIO=1",
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
