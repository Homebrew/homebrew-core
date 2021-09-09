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
    sha256 arm64_big_sur: "4dc938479255a2d2cb8455e75a84bbc2367b0db9822b27ab4823b0241405791e"
    sha256 big_sur:       "1f1abc3fe6748eb8b70642a0301aed7170ffa0333a9bab5c25e4091ff7167028"
    sha256 catalina:      "1d5508a4bb61348127d9d4d605d3b90d55d4e3d716398d1fed50ab1f513ece69"
    sha256 mojave:        "7fb9bec98e245eb10c40a95b8f73ded57bc6692ea921921cbe8b2d31fc57228f"
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
