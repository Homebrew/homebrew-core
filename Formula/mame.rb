class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "https://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0244.tar.gz"
  version "0.244"
  sha256 "843c917edc46008a27b439a1fc66fc12a27c84e55e08753b963789e5614cebf7"
  license "GPL-2.0-or-later"
  revision 1
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
    sha256 cellar: :any,                 arm64_monterey: "cafe5962e905d7ea9401cace95e71c9836ceb692e01033bf1ee2ed5e95f7d1a2"
    sha256 cellar: :any,                 arm64_big_sur:  "00f96b79f5f285f321ae256ba4d8935a1cbc9335936aaddc1b7e0b478e8c63d8"
    sha256 cellar: :any,                 monterey:       "567ce6f50e471f814a984993ae453d19b88b0f1abeacbab03a116c2e61c24918"
    sha256 cellar: :any,                 big_sur:        "efae2663babbd163fd019113effa55eb5b0496e8508ef38b90e6810f41c65bd9"
    sha256 cellar: :any,                 catalina:       "e460d923eba6ca00451d7ed2f57252e84134cdcf35dbfc67652ab1bb80f37aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4a38df94c7c3d6474699bd2077c6118c6ffd6b69067a4bc2dbc366624a44713"
  end

  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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
    depends_on "gcc" # for C++17
    depends_on "pulseaudio"
    depends_on "qt@5"
    depends_on "sdl2_ttf"
  end

  fails_with gcc: "5"
  fails_with gcc: "6"

  # Apply upstream commit to fix build with newer GCC.
  # Remove with next release.
  patch do
    url "https://github.com/mamedev/mame/commit/034e0d2c87a16e90783f742f39850dc7d85def1f.patch?full_index=1"
    sha256 "cc7da44c9ca8caca26756175340644e1284a6d3692a1aa7320e85167a31e85c8"
  end

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
