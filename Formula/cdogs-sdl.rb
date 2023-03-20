class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/1.4.1.tar.gz"
  sha256 "99aa698ba652e6b06d0eb18a9de5634dab798abb47beec1533050e33719fad00"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "de9c3850c0eee24390c110dd02929909ba4b4f05dc8d4fa3260b3554fa7ecc8f"
    sha256 arm64_monterey: "6c13ebde6728dc7ab2c25916667e5205697db6a177e97d66155d464ab83c7d52"
    sha256 arm64_big_sur:  "c93e343a00166445d7f60a213c05ea30f27f092835ade2a00c0f6af98ef77e8c"
    sha256 ventura:        "bc3ffa1e3ebf389375bc83d90a400916cb5604be532efa2e931818f2b1061799"
    sha256 monterey:       "91baa755bfc8c8bbcb7bfa3d839652085262dc82426fe35ca8e417bfff6a3583"
    sha256 big_sur:        "1885288160562a14e5b4049e5f11a9b44aaaf3849336630214524d5922e2d4c1"
    sha256 x86_64_linux:   "5e17f6cb49b71ec1fec5bd095cb6d651729c3252efee3e9d967b601301a1b103"
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
