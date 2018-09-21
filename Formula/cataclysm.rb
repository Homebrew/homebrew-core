class Cataclysm < Formula
  desc "Fork/variant of Cataclysm Roguelike"
  homepage "https://github.com/CleverRaven/Cataclysm-DDA"
  url "https://github.com/CleverRaven/Cataclysm-DDA/archive/0.C.tar.gz"
  version "0.C"
  sha256 "69e947824626fffb505ca4ec44187ec94bba32c1e5957ba5c771b3445f958af6"
  revision 1
  head "https://github.com/CleverRaven/Cataclysm-DDA.git"

  bottle do
    cellar :any
    sha256 "1c28c1bc74e941c741f682d9460af8ff2200a6189bc3cae5467f4b461e5a918e" => :mojave
    sha256 "c7bbaff919572a6c1bc00fb30b5038c567106de67c8a41d5b84f7c2acec8555a" => :high_sierra
    sha256 "305fe2048d73af85ae4d7cfbb71f23532ec66de88d75959648c1186d8f8da035" => :sierra
    sha256 "436d0b956cd5c0470926a416dc22e98ad0b846172c7ab58737665eb0e62eecfa" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "lua"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  needs :cxx11

  def install
    ENV.cxx11

    args = %W[
      NATIVE=osx
      RELEASE=1
      OSX_MIN=#{MacOS.version}
      LUA=1
      USE_HOME_DIR=1
      TILES=1
      SOUND=1
    ]

    args << "CLANG=1" if ENV.compiler == :clang

    system "make", *args

    # no make install, so we have to do it ourselves
    libexec.install "cataclysm-tiles", "data", "gfx", "lua"

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
