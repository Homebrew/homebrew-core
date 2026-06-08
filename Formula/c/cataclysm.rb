class Cataclysm < Formula
  desc "Fork/variant of Cataclysm Roguelike"
  homepage "https://github.com/CleverRaven/Cataclysm-DDA"
  url "https://github.com/CleverRaven/Cataclysm-DDA/archive/refs/tags/0.I.tar.gz"
  version "0.I"
  sha256 "1e4a6e1f70d805d01c97c71294eb45aad47f56f1e895fa783127e20298ee3249"
  license "CC-BY-SA-3.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.(?:\d+|\w))+(?:[_-]\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b85a378c456fe642a8a754371375e5976d5f03e2ea7bfc3973dad42c7f3ca5f1"
    sha256 cellar: :any, arm64_sequoia: "f864e5b641aeb05177f24ffb6ec6af6496060c021400227790017cde54587bfd"
    sha256 cellar: :any, arm64_sonoma:  "f4bbdcf29fa295fc2f1935afbaf85956d43047cd6ef65a97a4ccb4e968aa0055"
    sha256 cellar: :any, sonoma:        "9de90362620a41e99a2d3f03cd42ac473f59ce60f03ae97e6e47761f8267dc7e"
    sha256 cellar: :any, arm64_linux:   "643c8d9c04d3f8cec7a38943d29cc4ff05a295847b872b7feb8ab10f8478b4c4"
    sha256 cellar: :any, x86_64_linux:  "c2cdfdc0d0b74612b9c345a5b42ebf0494fbdf4a4e628cbfdabfeeb32aefb6dd"
  end

  head do
    url "https://github.com/CleverRaven/Cataclysm-DDA.git", branch: "master"
    on_macos do
      depends_on "freetype"
    end
  end

  depends_on "gettext" => :build # for msgfmt
  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
    # make user config directory
    user_config_dir = if OS.mac?
      testpath/"Library/Application Support/Cataclysm"
    else
      testpath/".cataclysm-dda"
    end
    user_config_dir.mkpath

    # "Error while initializing the interface: SDL_Init failed: No available video device"
    ENV["SDL_VIDEODRIVER"] = "dummy" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # run cataclysm for 50 seconds
    tries = 0
    pid = spawn bin/"cataclysm"
    begin
      sleep 5
      assert_path_exists user_config_dir/"config", "User config directory should exist"
    rescue Minitest::Assertion
      retry if (tries += 1) < 10
      raise
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
