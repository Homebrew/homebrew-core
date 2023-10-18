class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/1.5.0.tar.gz"
  sha256 "ca1a25fae68ddaf5e05dcc1cfe07d786863026599865111782ac6b2aa7a2f73f"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "e98f5afcb97d4b21f52afd14bff13b4ad9e2c6b98b36c2e5a22acf35cb342295"
    sha256 arm64_ventura:  "85bb144f474cfd58dd6abaea3a4a46e6b156decd58b026af8c7f97147a8a8454"
    sha256 arm64_monterey: "401c109ca7a1e2001989284902d1b2c3f861d21ba1fac5537ce75558c0a43e4d"
    sha256 sonoma:         "429f62c0d2f5a0299ce10bdda8133646f7f3160ed4caacc77658dcdae58de61a"
    sha256 ventura:        "7d8e4a34d38d70e8e8fa5cd15fd53d5ab00b83edb752e664c43a8367cf5f5596"
    sha256 monterey:       "c125ecd6f390d45e4ad45860c0068e6efa155737f27f7ef70cca74783b9eadab"
    sha256 x86_64_linux:   "3d9de87a4a0f34dd18860a8a5f7d2ba9f7bb39d561d9fe81741676d4f46db946"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on "python@3.12"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  on_linux do
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "mesa"
  end

  def install
    args = std_cmake_args
    args << "-DCDOGS_DATA_DIR=#{pkgshare}/"
    system "cmake", ".", *args
    system "make"
    bin.install %w[src/cdogs-sdl src/cdogs-sdl-editor]
    pkgshare.install %w[data dogfights graphics missions music sounds]
    doc.install Dir["doc/*"]
  end

  test do
    pid = fork do
      exec bin/"cdogs-sdl"
    end
    sleep 7
    assert_predicate testpath/".config/cdogs-sdl",
                     :exist?, "User config directory should exist"
  ensure
    Process.kill("TERM", pid)
  end
end
