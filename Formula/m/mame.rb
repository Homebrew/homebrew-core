class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0259.tar.gz"
  version "0.259"
  sha256 "46baf431079a3373ffe8d984b3ba5d62ad5b1d5e356d1f60cf60f6ad03d4cec6"
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
    sha256 cellar: :any,                 arm64_sonoma:   "ac5517e59ed784618a140d572e6a64735d2c55309aa3745c44ebb527eb34b4f0"
    sha256 cellar: :any,                 arm64_ventura:  "fca7fcd0e57783ad583b667ad41b882129f71901f5cb258215ddd48a192f248b"
    sha256 cellar: :any,                 arm64_monterey: "6e2a9e683bcc94646372671c354b44ec36fcf00620c827e6011d3b032e5df82a"
    sha256 cellar: :any,                 sonoma:         "d19490eaaea1ed762a047111846f1073fd9359e645557c975017e100c3ff7f2a"
    sha256 cellar: :any,                 ventura:        "53cf919e7ca2d9bad186ba71130581c8aae0b1c3231c18025e177438c4a67f4b"
    sha256 cellar: :any,                 monterey:       "de2efbfc73a14076973f94bdf067bd4749aa121babd95444b8e8e0c92c9d440e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5a47e08c1030947d5e627192b6db1c49e64977ec99416ad11b1191457238a54"
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
