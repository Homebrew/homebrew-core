class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/0.8.0.tar.gz"
  sha256 "ae5f493cfbbb5809824af79b164bd9a2ab7f7cfeb32468ff48f36b4a14982aba"
  license "GPL-2.0"
  head "https://github.com/cxong/cdogs-sdl.git"

  livecheck do
    url "https://github.com/cxong/cdogs-sdl/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 "66687e6a3548b98f7fd709efd02c8b859720366ae4cce99a5bbd7912fbaeefaa" => :catalina
    sha256 "268d71dc819666f503df8baf456e8c67ae656120325c220cbf61c24180ba539d" => :mojave
    sha256 "867cda02b913848c1c3ceb77b5bd3830e744297bbb03924d55030630b8b6af9c" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
