class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/0.11.1.tar.gz"
  sha256 "9c077b363859f22e5701f9fe1a0b3cf5f9e3464cf7110942f8ad7e70e833d6b1"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "7feec1f90645b5f0d406f9def13136e6d47684408140d082148d6312214beede"
    sha256 big_sur:       "1f5859a0f9e609e5a52acab23689ecacb6da597c5a3b6704fe78e1ab3a362224"
    sha256 catalina:      "0225ae38c33d204cc790842c9ccea96ed14794a8995810ac82207aa0d825d07d"
    sha256 mojave:        "4ede0386ee8cb4bc5f0dfd1c2fc2b310f631e7fa7a5383979a84dd56c98e3380"
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
