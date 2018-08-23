class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/0.6.2.tar.gz"
  sha256 "d6f421c760b15b706bdfc79ed8d18802dc2e8efeefabb69a31679c9b51f328ab"
  head "https://github.com/cxong/cdogs-sdl.git"

  bottle do
    sha256 "9530302fcce7df71e0e5cb97390af1fa8a8e7e4ccc4deeff92a0a0509d5a704a" => :mojave
    sha256 "aabf4faff2a2da410e14079a9520ea715106a294edf8748edad7bf480cedd605" => :high_sierra
    sha256 "b612f4fdf5d7f15e2ff88a5045437d1d411e254e6cda143d3256870bc5b2a30c" => :sierra
    sha256 "c154d6101f4b903488527a604b570e28703a19854da31d56e082444fe5dda1a5" => :el_capitan
    sha256 "535668e2f4619dde88da207249a2bbaaecd34d0972ce6f87947868518d7a6a54" => :yosemite
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
    prefix.install "src/cdogs-sdl.app"
    bin.write_exec_script "#{prefix}/cdogs-sdl.app/Contents/MacOS/cdogs-sdl"
    pkgshare.install %w[data dogfights graphics missions music sounds]
    doc.install Dir["doc/*"]
  end

  test do
    server = fork do
      system "#{bin}/cdogs-sdl"
    end
    sleep 5
    Process.kill("TERM", server)
  end
end
