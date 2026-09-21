class Cataclysm < Formula
  desc "Fork/variant of Cataclysm Roguelike"
  homepage "https://github.com/CleverRaven/Cataclysm-DDA"
  url "https://github.com/CleverRaven/Cataclysm-DDA/archive/refs/tags/0.I-1.tar.gz"
  version "0.I-1"
  sha256 "27e35a0a5181f88f0929bef180ca0465d00e606e569911cb02d97b59b8b5768a"
  license "CC-BY-SA-3.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.(?:\d+|\w))+(?:[_-]\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dd539e50c159a9cd005ef1115144ea25edf90163852d6e7efeecb29b0209a929"
    sha256 cellar: :any, arm64_tahoe:       "4f2b5416cfd128d4b52f2d4143fc7fd4428653f8286cf6f7c3d8b53b763e83fb"
    sha256 cellar: :any, arm64_sequoia:     "b2a9a536de070af17504483b6fcb6279f9810fdb0de9806a8d3287c4c07606bb"
    sha256 cellar: :any, arm64_linux:       "9dcfa203fa51d1461dedc072944eecea3400679ae47f5f69df9f8d32e648ec48"
    sha256 cellar: :any, x86_64_linux:      "2819f3dac67b7c5dcf314f0f3349bc2c1a058fd745a0a53690a2a9cb17d3f916"
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
  depends_on "sdl2-compat"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    args = %W[
      NATIVE=#{os}
      RELEASE=1
      USE_HOME_DIR=1
      TILES=1
      SOUND=1
      RUNTESTS=0
      TESTS=0
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
    ENV["SDL_VIDEODRIVER"] = "dummy"

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
