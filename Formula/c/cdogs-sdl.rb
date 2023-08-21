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
    sha256 arm64_ventura:  "de84293a061b921d52579e08dee01d406af21e5c2e0c879334b6671323e916bf"
    sha256 arm64_monterey: "d47ee8ce5044bad8f2c37ce34145a82a6b2f6e35d7177d893889c4e58bd1d670"
    sha256 arm64_big_sur:  "85268b66b49fd79243743b889b392060f721098f365f84ec54dc55d2c8083763"
    sha256 ventura:        "5f36be72087ecf02d4c7e43abe33c549d260b218edcae8d9edb53c7d4e215c78"
    sha256 monterey:       "55c75aaf8a865a6da8310c21956abd2910d5acb1c2589b13f397693b7782c608"
    sha256 big_sur:        "460fd533f9a602c86a59015bbc9c7ff329f92735be4d05f67a98e6a4a2717457"
    sha256 x86_64_linux:   "ab5e85ae2fe3ac76ed6408063ddc5abdf7e6f59f378ee062c1f390c3083d08d7"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on "python@3.11"
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
