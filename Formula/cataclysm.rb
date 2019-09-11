class Cataclysm < Formula
  desc "Fork/variant of Cataclysm Roguelike"
  homepage "https://github.com/CleverRaven/Cataclysm-DDA"
  url "https://github.com/CleverRaven/Cataclysm-DDA/archive/0.D.tar.gz"
  version "0.D"
  sha256 "6cc97b3e1e466b8585e8433a6d6010931e9a073f6ec060113161b38052d82882"
  revision 1
  head "https://github.com/CleverRaven/Cataclysm-DDA.git"

  bottle do
    cellar :any
    sha256 "24454f33d052b39afe8dbe1e82498e939754f45c8b370385485070b2efbed20c" => :mojave
    sha256 "f885e61b707330bf1346e215156a22956b3da5016e645ba3ef5d00829aac984a" => :high_sierra
    sha256 "f96c3b668439311126dc8064d0b3590aebb6e21ecd5bcba01303e78dca9c4a7c" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "lua" unless build.head?
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  def install
    args = %W[
      NATIVE=osx
      RELEASE=1
      OSX_MIN=#{MacOS.version}
      USE_HOME_DIR=1
      TILES=1
      SOUND=1
      RUNTESTS=0
      ASTYLE=0
      LINTJSON=0
    ]

    args << "CLANG=1" if ENV.compiler == :clang
    args << "LUA=1" if build.stable?

    system "make", *args

    # no make install, so we have to do it ourselves
    libexec.install "cataclysm-tiles", "data", "gfx"
    libexec.install "lua" if build.stable?

    inreplace "cataclysm-launcher" do |s|
      s.change_make_var! "DIR", libexec
    end
    bin.install "cataclysm-launcher" => "cataclysm"
  end

  test do
    # make user config directory
    user_config_dir = testpath/"Library/Application Support/Cataclysm/"
    user_config_dir.mkpath

    # run cataclysm for 5 seconds
    game = fork do
      system bin/"cataclysm"
    end

    sleep 5
    Process.kill("HUP", game)

    assert_predicate user_config_dir/"config",
                     :exist?, "User config directory should exist"
    assert_predicate user_config_dir/"templates",
                     :exist?, "User template directory should exist"
    assert_predicate user_config_dir/"save",
                     :exist?, "User save directory should exist"
  end
end
