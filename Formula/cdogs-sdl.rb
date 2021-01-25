class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/0.10.2.tar.gz"
  sha256 "3ab6036e65c83e98156317aebb3cd6013c8e25081fa8547007a25d299657f93d"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 "b5f985db36af5e627bf39534f1b12773ca83caf96b26965adea3824a7e939313" => :big_sur
    sha256 "4f2edb88b56c462e440ec9a7a28878b110512d9afafa2be8f69d2726df9d63c7" => :arm64_big_sur
    sha256 "2b0bc41a233dd6843ccdcf95badf04472e1e728d5bc36bd606aad7c5c1c3701a" => :catalina
    sha256 "a344081267233c5d78d4e03ce5eb8c1a3410da4e229a9b3758b61f7480cce693" => :mojave
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
