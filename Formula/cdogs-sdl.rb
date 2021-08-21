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
    sha256 arm64_big_sur: "9662f78d7f121c7bdbff1d7841e298ba5a4f4b1cf80fffdeafffffe196ce0e58"
    sha256 big_sur:       "ccfd4791ec40972d8a980d0c6f07ebb16b83e3f37c78da53054749cfc5492761"
    sha256 catalina:      "44c4387bfaa77bcaa175163f162f2c8050b1412d806ca9f7da7a2b01d290ad30"
    sha256 mojave:        "1041fc4e0bf76a608eff2afd8c800a5f7c422106f31960c165cb720fa68c42e4"
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
