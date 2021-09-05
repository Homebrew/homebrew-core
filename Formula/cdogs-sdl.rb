class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/1.0.2.tar.gz"
  sha256 "06e177d1a794f05d007bd5cf2c75e677b74384ac49242f86058d58d5001036e3"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "95c03621c90868e9156cb810ee5e16d8c9f96b2b048a26cc9928a2f1001ff7d6"
    sha256 big_sur:       "ab49d0f818e3eb1272ec678cebe71bec3f04906b71fc71cfb7915819bb49f691"
    sha256 catalina:      "58c39409dea720ce2ec7ea2c290c42ca48df7a770190c35229ca740a3e710de4"
    sha256 mojave:        "feeff17d9b0cd8b0b10d4253b9590ceb7c0a8726cb19c648b7fbe23969f7a415"
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
