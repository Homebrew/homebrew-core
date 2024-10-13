class Cataclysm < Formula
  desc "Fork/variant of Cataclysm Roguelike"
  homepage "https://github.com/CleverRaven/Cataclysm-DDA"
  url "https://github.com/CleverRaven/Cataclysm-DDA/archive/refs/tags/0.G.tar.gz"
  version "0.G"
  sha256 "e559d0d495b314ed39890920b222b4ae5067db183b5d39d4263700bfd66f36fb"
  license "CC-BY-SA-3.0"
  head "https://github.com/CleverRaven/Cataclysm-DDA.git", branch: "master"

  livecheck do
    url :stable
    regex(/([^"' >]+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "fc475b0ecef7dc2d0739fc1ad7eec5c0fb220080a7722d3df9e221143776c6be"
    sha256 cellar: :any,                 arm64_sonoma:   "1f0baa0478cd23de28c5ad1d2b10b90979b0c627a6445f15b287193d760c8493"
    sha256 cellar: :any,                 arm64_ventura:  "99558da9dc0aff5d3e520504578ba4112a1ccd25be503414c8b35473b9b4e298"
    sha256 cellar: :any,                 arm64_monterey: "9e83a6fc0c9ae9ae1364fe3dcaa56192b9324f7d2423b8e4df309f1044a717b4"
    sha256 cellar: :any,                 arm64_big_sur:  "655e4c659d55a1844ef8ebb910f297bbb27ff8b10905c6e9e95232b76cdf1d1b"
    sha256 cellar: :any,                 sonoma:         "3355476707fda486bb180c4320063c03cf3cb16f6e084d835597089c08d55865"
    sha256 cellar: :any,                 ventura:        "6f54c0f3258b4231e38dd38d9e094cdd24389ebb1cdb423c3fda60396d588fc9"
    sha256 cellar: :any,                 monterey:       "062842315c06a4e816fc9885e4b670a306521dbc3b78537e83a6fb304790854d"
    sha256 cellar: :any,                 big_sur:        "a395f1cc45907a5f83ddd9499fe7178c0220f1af20b6910901a4b434cc95b82c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14498eae0539dcfee7034f2975d7889b62c50c0684082954c0695fa4293db7dd"
  end

  depends_on "pkg-config" => :build

  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    args = %W[
      NATIVE=#{os}
      RELEASE=1
      USE_HOME_DIR=1
      TILES=1
      SOUND=1
      RUNTESTS=0
      ASTYLE=0
      LINTJSON=0
    ]

    args << "OSX_MIN=#{MacOS.version}" if OS.mac?
    args << "CLANG=1" if ENV.compiler == :clang

    system "make", *args

    # no make install, so we have to do it ourselves
    libexec.install "cataclysm-tiles", "data", "gfx"

    inreplace "cataclysm-launcher" do |s|
      s.change_make_var! "DIR", libexec
    end
    bin.install "cataclysm-launcher" => "cataclysm"
  end

  test do
    # Disable test on Linux because it fails with this error:
    # Error while initializing the interface: SDL_Init failed: No available video device
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # make user config directory
    user_config_dir = testpath/"Library/Application Support/Cataclysm/"
    user_config_dir.mkpath

    # run cataclysm for 30 seconds
    pid = fork do
      exec bin/"cataclysm"
    end
    begin
      sleep 30
      assert_predicate user_config_dir/"config",
                       :exist?, "User config directory should exist"
    ensure
      Process.kill("TERM", pid)
    end
  end
end
