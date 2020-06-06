class Cataclysm < Formula
  desc "Fork/variant of Cataclysm Roguelike"
  homepage "https://github.com/CleverRaven/Cataclysm-DDA"
  url "https://github.com/CleverRaven/Cataclysm-DDA/archive/0.E-2.tar.gz"
  version "0.E-2"
  sha256 "41546e877e2eee79c8492b3ec808ef53a4b9b208d788dac2b1a570ef143426e9"
  head "https://github.com/CleverRaven/Cataclysm-DDA.git"

  bottle do
    cellar :any
    sha256 "bbd96abbc2ac1ddfabb2ab2febff1b0653d95210b84e6ea8a1dec73a530d8647" => :catalina
    sha256 "c2c44f2a965153e4258c8c3daf6772bd7f5c9935320d2e1975cb63fb6909f095" => :mojave
    sha256 "1eb07ba0e992116ae94d8b380d520139d686997e6700834f2db4bb1cded1401f" => :high_sierra
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
    user_config_dir = testpath/"Library/Application Support/Cataclysm/"
    user_config_dir.mkpath

    # run cataclysm for 7 seconds
    pid = fork do
      exec bin/"cataclysm"
    end
    sleep 7
    assert_predicate user_config_dir/"config",
                     :exist?, "User config directory should exist"
    assert_predicate user_config_dir/"templates",
                     :exist?, "User template directory should exist"
    assert_predicate user_config_dir/"save",
                     :exist?, "User save directory should exist"
  ensure
    Process.kill("TERM", pid)
  end
end
