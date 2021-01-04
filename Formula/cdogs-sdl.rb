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
    sha256 "ecfce356cd0f4b376a1a8cb7350dc32dc8103a6f88b3c80899237918d02aabee" => :big_sur
    sha256 "284ec1992ac8451edada6781f30eec6e724e91ee2d2673b588b5ba010f9b5b7d" => :arm64_big_sur
    sha256 "47c3ec4b25b74d6eaddcc637e0af2b79c7c9c5e30fce053586280427c1e47dd1" => :catalina
    sha256 "3bc1ed2ed0e30ac32ebe50997ead19a53b57aa40b9d1f0c2c3de5420e545ebbd" => :mojave
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
