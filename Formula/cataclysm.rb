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
    sha256 "ddb29138ec2243c2dd68f29782161ee740a75d19f9757ca085fe1f43c5ba1a37" => :mojave
    sha256 "6e602bda6632b19b42f907e952407b9669398604c7ee43aa19dbcca50166ab71" => :high_sierra
    sha256 "1a821cdc40c5170e95c32877acdeb086fedecf366a505e27c559c557003b31de" => :sierra
    sha256 "939d8b6b945457b91f77860f31675d9facf57a842e1b033ea4ed889ee91ab165" => :el_capitan
    sha256 "e7ea748e9dd53bd0ace6c8456c4eb351616dc9c879621b6724ce742ae2b0d4f2" => :yosemite
  end

  needs :cxx11

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "lua"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"
  depends_on "libvorbis"
  depends_on "libogg"

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
    mkdir(user_config_dir)

    # run cataclysm for 5 seconds
    game = fork do
      system bin/"cataclysm"
    end

    sleep 5
    Process.kill("HUP", game)

    assert_predicate user_config_dir/"config",
                     :exist?, "User config directory exist"
    assert_predicate user_config_dir/"templates",
                     :exist?, "User template directory exist"
    assert_predicate user_config_dir/"save",
                     :exist?, "User save directory exist"
  end
end
