class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/0.7.3.tar.gz"
  sha256 "0a19a619dd02f647d680b245abc97359e04cdc4231a61b86397a37100907195c"
  head "https://github.com/cxong/cdogs-sdl.git"

  bottle do
    sha256 "6fb64eabb3777469eae01c7a106ae23a476207acc464dce439ee0df32113f559" => :catalina
    sha256 "0d9364354ce369be43114c059c8ae55fdc9a9f77534463f919cb3fc491f63c79" => :mojave
    sha256 "fa1acdcace9940b7e633d21f42159ff72aa55095d995f8331fba40b4aa85f31e" => :high_sierra
    sha256 "811a7269fa69ba5fde0a15486e019c91f0d6b81afc644d7ed782f1d7e144917e" => :sierra
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
    server = fork do
      system "#{bin}/cdogs-sdl"
    end
    sleep 5
    Process.kill("TERM", server)
  end
end
