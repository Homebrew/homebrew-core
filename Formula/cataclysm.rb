class Cataclysm < Formula
  desc "Fork/variant of Cataclysm Roguelike"
  homepage "https://github.com/CleverRaven/Cataclysm-DDA"
  url "https://github.com/CleverRaven/Cataclysm-DDA/archive/0.F.tar.gz"
  version "0.F"
  sha256 "f7c373cd2450353f99a5c3937a72ae745f5440531266d2d596e5bf798001ac57"
  license "CC-BY-SA-3.0"
  head "https://github.com/CleverRaven/Cataclysm-DDA.git"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/([^"' >]+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "38038c0ee662973336ebff5e1c114cf56970d9c52cc013995d6ba99521969ee1"
    sha256 cellar: :any, big_sur:       "75e52a9ac89e5e8705fc6be314694c3c1f9ce9b08200bea5834614b7ad524a0e"
    sha256 cellar: :any, catalina:      "850ad951b4bca48ea91f38655ca91330c5817ae80da85a4e27775ce59e2e79eb"
    sha256 cellar: :any, mojave:        "b0c25bb24b3780f1722b480519040ccdae52cd34fea85e6bdb50e92253d9c33b"
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
    sleep 30
    assert_predicate user_config_dir/"config",
                     :exist?, "User config directory should exist"
  ensure
    Process.kill("TERM", pid)
  end
end
