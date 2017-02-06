class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/0.6.2.tar.gz"
  sha256 "d6f421c760b15b706bdfc79ed8d18802dc2e8efeefabb69a31679c9b51f328ab"
  head "https://github.com/cxong/cdogs-sdl.git"

  bottle do
    sha256 "d9d3ee8835fb9af9c08ec84b9b59e632a4f40485497bff41c42e062bab5f33e2" => :el_capitan
    sha256 "e0d3a2a9402ac81328412c55042ebb7ebc8ff57c5499ffb1e8d0e6e7d57a34bd" => :yosemite
    sha256 "ba448b78e268752f265ac42e40a1e6e24a6f0063073eb814c9149f8d82ee1393" => :mavericks
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
    pkgshare.install ["data", "dogfights", "graphics", "missions", "music", "sounds"]
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
