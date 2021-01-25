class Cataclysm < Formula
  desc "Fork/variant of Cataclysm Roguelike"
  homepage "https://github.com/CleverRaven/Cataclysm-DDA"
  url "https://github.com/CleverRaven/Cataclysm-DDA/archive/0.E-3.tar.gz"
  version "0.E-3"
  sha256 "21ac5226a996ac465842f188cadea8815eae7309fe38cf8d94de2f8ac97cd820"
  license "CC-BY-SA-3.0"
  head "https://github.com/CleverRaven/Cataclysm-DDA.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/([^"' >]+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "0e93a967d9e4e01129912388ef9b9b0de954d25088ee65c05a6fea80aca7acbb" => :big_sur
    sha256 "aacc35c573fa5f841054e73d76c1c954086a990f5821372ab0716652d4b7ee7a" => :arm64_big_sur
    sha256 "c81600f8324c60d92121e5134fbb26a1212375c5e0c017363cceb473e0ef10e7" => :catalina
    sha256 "2a3c5ef376aaeb2ee93ddbf3b6ebbb1997056411d48369454283b9518a4da345" => :mojave
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
    assert_predicate user_config_dir/"templates",
                     :exist?, "User template directory should exist"
    assert_predicate user_config_dir/"save",
                     :exist?, "User save directory should exist"
  ensure
    Process.kill("TERM", pid)
  end
end
