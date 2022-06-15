class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/1.3.1.tar.gz"
  sha256 "3b863a092b23da8b210383831ff490a10dd6fda77b997fe2bf39cedcfa0a8937"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "fce15682cd3a9d2157c23a8db9a1286f6f09a8895449b7f7d38c80bfa0cfbb19"
    sha256 arm64_big_sur:  "d776112518767415709a708a2bc5b93e32615cf8bfb1ac4be7319c6e21b5e944"
    sha256 monterey:       "f334fc663f45367c575fc297ef9c7f87e1029f3ac15f4090ed012e6e612ca0fb"
    sha256 big_sur:        "7ee074276228f22a2693abf71eaf85293964c31e35767dd2815f5b8ae0b12d76"
    sha256 catalina:       "5ffa993027165105866a1e6782f7a7e64d3082102355e99ae994429f75891a2c"
    sha256 x86_64_linux:   "6408bbad5c9f4d9baf021730766af721544d64d7adb6cf4fa6ac763efaad9a71"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on "python@3.10"
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
