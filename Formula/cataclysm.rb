class Cataclysm < Formula
  desc "Fork/variant of Cataclysm Roguelike"
  homepage "https://github.com/CleverRaven/Cataclysm-DDA"
  url "https://github.com/CleverRaven/Cataclysm-DDA/archive/0.F-2.tar.gz"
  version "0.F-2"
  sha256 "0c607071302265af07a9b299d0bbdb0716b2b929caa3cbcf435cd415b14ccc56"
  license "CC-BY-SA-3.0"
  head "https://github.com/CleverRaven/Cataclysm-DDA.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/([^"' >]+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "d6ba9bb02eb973e0cf4a2d569d1ea90f28806aa060d59210f2593bbfd1d22754"
    sha256 cellar: :any, arm64_big_sur:  "ca14eb2f01555ab74e44e76e939c41d477c675a7b157e34a17f06d5ce3e56fc2"
    sha256 cellar: :any, monterey:       "aec3cf18d974b4fd478673a61c1c31290ce6e465a99ca030b132c61c5dad2c85"
    sha256 cellar: :any, big_sur:        "fe3e6ecd6e489a2f3acf6fef68308a40b0ca364f821fbdb138e81849aa52a9b3"
    sha256 cellar: :any, catalina:       "655026ec19a856b436722efabd34507e6768468a993dc2768f7c1583b86c3641"
    sha256 cellar: :any, mojave:         "cf4a1e7e99ac3dd4af801918385bafc6b3425b555436086fcaa7e22c371f9ff7"
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
