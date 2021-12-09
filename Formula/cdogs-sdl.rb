class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/1.2.0.tar.gz"
  sha256 "20ed6d261dcc1a6c5f197ffa49aeb2b9c30d2ece514745b144c6ebaeada9bcaf"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "c159c6d0a53ab555f2b3f473967cc8c0c11ad235a811399f2004d8f29c77a7b8"
    sha256 arm64_big_sur:  "b71a4e9df6b6f42a8db31498cfc49ab46b5b306d0d253e23ecdb5a962303a782"
    sha256 monterey:       "9ece0f8d47f2fc0523aae22669004bac107760b58a9ffe34fe933fd80b516e3d"
    sha256 big_sur:        "73391582f496c9104dad24676514d602289085cf130763ee06c1f98594cfbad4"
    sha256 catalina:       "0e1adcac780529aa0744956d6cd3aea7c1cf920576cad4cfcfbb4ad4475688ba"
    sha256 x86_64_linux:   "f4ce24c36f22aa62ef0838000c884a98a17bf065685b46ad6217bdf9c13dd27f"
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
