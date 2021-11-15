class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/1.1.1.tar.gz"
  sha256 "a1a18efbd128249ac607f7bf04e09e4625d35509209be7e256461f2fabddd98e"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "1eeb228fb876c92c3809c3b1c4c3818b8ecb4917aa779a807eaf5b8a41763811"
    sha256 arm64_big_sur:  "9db72aa1904869a7bb28afc1c550ce26939efa6981f783dfbc5ff0ff60ae7920"
    sha256 monterey:       "e48b864e67aed9b18433a983f4aef44b374b61276c1421e7763ebebab9dbf12e"
    sha256 big_sur:        "47ac08b78f35ae9ec4ba966f16c824fa42163e1020eb3ec2d144ac9fca4e057c"
    sha256 catalina:       "10d48265e4705b1bda33270ff02beed252093aef168e1ce85ecd3e95d145ef3b"
    sha256 mojave:         "4973b9b193c93618a7e7cafd8223ecd9bda40c62e0ff0438497a829469e4557d"
    sha256 x86_64_linux:   "dc3a2562c440f36b419192cce13c3ca42e3397777d414286e230793360b7d554"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on "python@3.9"
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
