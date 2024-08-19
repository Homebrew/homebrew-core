class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/refs/tags/2.0.0.tar.gz"
  sha256 "fd0de995c324193377f145b42433a725cad3c6f3c08fc85b6b5b603436486922"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "0c06fcf333434a5b13e17fd91ba3b9b31520450a5c7fd44986737a0a711d12ac"
    sha256 arm64_ventura:  "3ae327f7a5f6473034cec1cb51f42ec292df6299deba802bdd23eaff5d1c4156"
    sha256 arm64_monterey: "fefa48f891d8fc500316990343a0330021d6e199660108effc499a8648ba284d"
    sha256 sonoma:         "d5a40c344fde65732951e96a943f37f9f2289a036bed9c4c49728c0b58b485a3"
    sha256 ventura:        "03a3e3436c67e3cfe68822e633990983fc583d3168c1768477a7909593bf7f0e"
    sha256 monterey:       "1c35166d79464ef255a1e07ce41a7e11fb2fc93a0d8dcbbd0b216abbfd8695f5"
    sha256 x86_64_linux:   "94c55093e7e842dff0c88e44b574563ce44af4f92fbf89c25b8d163692dce45b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on "python@3.12"
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
