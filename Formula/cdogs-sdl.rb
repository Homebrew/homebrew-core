class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/0.7.3.tar.gz"
  sha256 "0a19a619dd02f647d680b245abc97359e04cdc4231a61b86397a37100907195c"
  head "https://github.com/cxong/cdogs-sdl.git"

  bottle do
    rebuild 1
    sha256 "7b4abbbe4084475ccce4fd97cccf634be329455ac660c1190c1aebcc6cdf03f5" => :catalina
    sha256 "8cf4159493f97517f58f36a9b1821da13bd7055a1042543375f614ed22ff4512" => :mojave
    sha256 "c790b1f8d14f88eee49029870963ea7ece4c5d5b2137d6992ff043e70337bba1" => :high_sierra
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
