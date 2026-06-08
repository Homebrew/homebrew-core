class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/refs/tags/2.4.0.tar.gz"
  sha256 "0fde6aaf07db2156e5d4c8e448f0ddb4608ed3b92b89aae1e2c87b20866e451c"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "43cb95679ae4236f5f3b24a07e0419de27a93688cb610e5bfde88781e50fbc8a"
    sha256 arm64_sequoia: "0946f291de2aa944b2ad348bacdeda34c9c17c6ecb92d886ff777ed16a6443a0"
    sha256 arm64_sonoma:  "b3a876d3a2556e6cfb4784fc46ebbc4c4f0e1231c00d43a97668a754091092e8"
    sha256 sonoma:        "938c7c419cf215c4d118f079840b60d30877f25852a8d4893e6436d4cb7d4617"
    sha256 arm64_linux:   "d09d6dc4b6acda8cbef949250bf964568de9685dea0a0576296e286d20168f98"
    sha256 x86_64_linux:  "ef5c5f617815355ce474291696af44a88e8243c0b15a099ff0a97155ba43f68e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "python@3.14"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  on_linux do
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "mesa"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCDOGS_DATA_DIR=#{pkgshare}/",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    *std_cmake_args
    system "cmake", "--build", "build"

    bin.install %w[build/src/cdogs-sdl build/src/cdogs-sdl-editor]
    pkgshare.install %w[data dogfights graphics missions music sounds]
    doc.install Dir["doc/*"]
  end

  test do
    pid = spawn bin/"cdogs-sdl"

    max_sleep_time = 90
    time_slept = 0
    time_slept += sleep(5) while !(testpath/".config/cdogs-sdl").exist? && time_slept < max_sleep_time

    assert_path_exists testpath/".config/cdogs-sdl"
  ensure
    Process.kill("TERM", pid)
  end
end
