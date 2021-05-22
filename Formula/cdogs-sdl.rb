class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/0.12.0.tar.gz"
  sha256 "7ce391e8c9ebd4ca2579ace1bd8d486a8267ff1ec4719c862aba6960ad06bee9"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "61ad81eb1b5afea1a2a795f18819b1e96e36bbb26f496a1d5c850df1121d75a7"
    sha256 big_sur:       "62f9f47f483e24945b7a8b61ef55e0903a78840facb0bc35023752e67a449a3f"
    sha256 catalina:      "918c07a9f00a989883566c497e4b5cf34f298808e5b7d988f5f4beea71946980"
    sha256 mojave:        "225024bf197654173c9c9ba76ee54811c5fb8e7f1331e7520f741f2dd3ff8012"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on "python@3.9"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

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
