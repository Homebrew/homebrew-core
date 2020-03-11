class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/0.7.3.tar.gz"
  sha256 "0a19a619dd02f647d680b245abc97359e04cdc4231a61b86397a37100907195c"
  head "https://github.com/cxong/cdogs-sdl.git"

  bottle do
    sha256 "e26c3640130974477c5577df4d2629b07b8ea40af46abc9abab37d45608f530f" => :catalina
    sha256 "5e136002cb8733b5cd4ca11624e5175cf39d9909e99e211f8e1d8be08071dad8" => :mojave
    sha256 "2eefa54af63f981a35a4713234d43f0a5b451b66828f6a51d5d5c91748a64e6c" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
