class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/1.4.0.tar.gz"
  sha256 "4030bd8f6168b8f7ee152d0edb1d7a4b75920b7b7fb19a2f7e834508af9631cd"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "347894832909e1de174086da8c32df59db2203ed437bac258d3ed0b63c5b29ac"
    sha256 arm64_monterey: "37bd357a6fa43b4917c344d4104911c1bd0ff45175116ceb224c30dfe2d2f0ad"
    sha256 arm64_big_sur:  "171b3f82cffc78b64de25e9adcaf71630ac4696068498967051f43e1fab9fe5c"
    sha256 ventura:        "4975cf6406148f65989136965b5f9a4d06beab47f18bd3fee82ac5f97acb9487"
    sha256 monterey:       "3b584cbb629bc343fd60705b893da5cc2a9cfac4db08569fb35655099e199c00"
    sha256 big_sur:        "1cfe6f96b945dfcfeb91972ccf989b8cc8e6ca5d3af2040c3a97d4dd8c371800"
    sha256 catalina:       "3612bb1d64909b39d46e8510dc83d6d4c7a0c92eb1238da2d785d9597f99b460"
    sha256 x86_64_linux:   "2dbffcd25b20ca0f37da1a87dbc42a4509a1d9fefabe64344503e7c977dd6174"
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
