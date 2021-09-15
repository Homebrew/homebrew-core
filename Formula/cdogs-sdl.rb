class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/1.1.0.tar.gz"
  sha256 "c5be3a2d2777f727d7dab505266a952e134d91b8d34d0ba4e21a901316a247ca"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "fc7aa00d06e4f314cb10fb019711f18db18451e55fe6ab62a1e062173a6075fc"
    sha256 big_sur:       "8ebe2bea06dbd639ad50538b275557fc3dc5dcdd8fe2f5e7d3f55c145ee65eca"
    sha256 catalina:      "713ee17ca147d5e6847aecb0973b9b5e86526bb7995e857f02c433bb107dc4f2"
    sha256 mojave:        "7302c03db1cde8727fe27e51140d55148ad1659b3611c3f31dc5f51bc58c6967"
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
