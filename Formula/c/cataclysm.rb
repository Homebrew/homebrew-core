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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "492b7c7f2a66af205374ca334b4424cfe0beed549aacaac6e9380e1132cb366e"
    sha256 cellar: :any,                 arm64_sequoia: "c7262395e501e9f37bddc7a552c4b4e0f3b920f0aabef1eab3b26de586a43dd3"
    sha256 cellar: :any,                 arm64_sonoma:  "4f34105d17b58a4c9f6a807d524107d38f29d47fbb09eea1134708a1fab2ee8d"
    sha256 cellar: :any,                 sonoma:        "a7b35b49b7b630c8e30748a52cd20e9224a9bdb3b44ec0019124f6c5a6d9f416"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11de987a3cc2dea85f666402020210db6c9af56ba5c9f3594c3bb6169c58ef9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60f13c7d80e9b622b4153053872837e318be0aa3116535deaa138f49fc0a7a3b"
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

    # run cataclysm for 30 seconds
    pid = spawn bin/"cataclysm"
    begin
      sleep 50
      assert_path_exists user_config_dir/"config", "User config directory should exist"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
