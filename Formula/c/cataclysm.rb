class Cataclysm < Formula
  desc "Fork/variant of Cataclysm Roguelike"
  homepage "https://github.com/CleverRaven/Cataclysm-DDA"
  url "https://github.com/CleverRaven/Cataclysm-DDA/archive/refs/tags/0.H-RELEASE.tar.gz"
  version "0.H"
  sha256 "9fbd80d13321321d6ed1f5a736ab874e06d335429f2a51a39eefd2fa51feae68"
  license "CC-BY-SA-3.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.(?:\d+|\w))+(?:[_-]\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8dadb20312e5e2a96f0b9e07de09a0f84b4c7e754932a183861141a2a62b25fd"
    sha256 cellar: :any,                 arm64_sequoia: "2cce9de78e3da9ad7fc8eeaa2998b468bff0d6d342ebd2dc5dd0683821569ac6"
    sha256 cellar: :any,                 arm64_sonoma:  "175fc6b0ea8289e9c76da22277ed6eb35dde251dd88416f2ef8edaea83f15213"
    sha256 cellar: :any,                 arm64_ventura: "cbbbf7dcd3b21d4db6f5e7994677269b79e871c43eecde80ea9fa16c84065859"
    sha256 cellar: :any,                 sonoma:        "2fdb081a3ec309197e0909ad4d9fa32802595e661370b9c1a507d6942fa155d0"
    sha256 cellar: :any,                 ventura:       "7cac6a7e522742a8657f2f0bcbfa3a8814390c2ff47dfea131d7f03028517768"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c58fbd6b591afb768dcca07ff541c9f8871bc99a59ab34aae14e281048f06c47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e864a77dc73f1e8c043b4b7c0c7d728e23ce09f77d0c75cf258e87cf8cb3d42"
  end

  head do
    url "https://github.com/CleverRaven/Cataclysm-DDA.git", branch: "master"
    on_macos do
      depends_on "freetype"
    end
  end

  depends_on "gettext" => :build # for msgfmt
  depends_on "pkgconf" => :build
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
    pid = spawn bin/"cataclysm"
    begin
      sleep 50
      assert_path_exists user_config_dir/"config", "User config directory should exist"
    ensure
      Process.kill("TERM", pid)
    end
  end
end
