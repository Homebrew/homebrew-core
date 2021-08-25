class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/1.0.0.tar.gz"
  sha256 "aba3679ecf41ffad60e8710b5583af3b037819b7f1ae6d75055e6fb79b53eded"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "eca1916d31a7cfc51ef0c92eb93a8bc53564e4d9a43a5c3e5f3871f8f6421451"
    sha256 big_sur:       "a98c3fc74364e56c00ed274aa8f6c28b66505ea0f1f029a64119962cfe75ccb1"
    sha256 catalina:      "6f17dbacaa771205674842a94cfcae8f5c2e6c703385df3dceb11fa21830b1e0"
    sha256 mojave:        "0c883a2c5d7482351b628002645edb25dff3c5b2e002be40010cb11e76559b2f"
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
