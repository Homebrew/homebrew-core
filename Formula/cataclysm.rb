class Cataclysm < Formula
  desc "Fork/variant of Cataclysm Roguelike"
  homepage "https://github.com/CleverRaven/Cataclysm-DDA"
  url "https://github.com/CleverRaven/Cataclysm-DDA/archive/0.F-3.tar.gz"
  version "0.F-3"
  sha256 "5cde334df76f80723532896a995304fd789cc7207172dd817960ffdbb46d87a4"
  license "CC-BY-SA-3.0"
  head "https://github.com/CleverRaven/Cataclysm-DDA.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/([^"' >]+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e150bf1941d1cd877cf4916b077e26fa92f6e455537239819fb47507ce9bc5ea"
    sha256 cellar: :any,                 arm64_big_sur:  "022d3fea15cfc0a322ae88e5b2f1b5cfc43cf1800e47edb0c67a7497ea02a8e6"
    sha256 cellar: :any,                 monterey:       "4eded1f647775447ce5e3ee1db263adf3af99f744de14c1d51c6181c5f94e1ef"
    sha256 cellar: :any,                 big_sur:        "e0b9a3933fd920e5955cd0464845f7a9e7dfe808b67b5bb2858239843755e47f"
    sha256 cellar: :any,                 catalina:       "74397a9575dc94327a5c2eaf9b1a8a306699c991847e6ecf642f37e439f42d2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95b275bc970b8053631ac25536970188208c7b08fcdb86c75e55425b45bdf16e"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

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
