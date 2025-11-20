class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/refs/tags/2.3.2.tar.gz"
  sha256 "e2f56262629b175d4a387f6491696edc0a5b9420c9be8e9aa12b60feaa4fefa1"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "493a195761b03422dbb086028bdb68d23ce467a4f531e300030b3d3ae6feafd2"
    sha256 arm64_sequoia: "4e24f31b8ee89a741c871ea1bf432a051a0dbbc5c44c3445f8d924f7a6c98e96"
    sha256 arm64_sonoma:  "5ccba356364ef62cbe33de604239191571d00368b296efbcf5443bd344c88f08"
    sha256 sonoma:        "83fb9b4b19b256cf9410d96234f13e086290f460bb94aaf8877dd16436e465cb"
    sha256 arm64_linux:   "ff74f2369565cd06639a6b9ffe97af60510dd98ce4b1110c5e584244b48bc1e7"
    sha256 x86_64_linux:  "0aff885c980dc56d382465c2b9dfbca48e4694bd49298867407159afc8fc2f26"
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
