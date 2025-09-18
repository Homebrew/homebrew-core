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
    sha256 arm64_tahoe:   "b2b848260d98548d3a6967b49fc5a160b579b4acae8f4e54c1bdcebcb1a4bb14"
    sha256 arm64_sequoia: "ddb726d445197fd15fc5837fb71ffc252a07ed1b41b5d5104cbb8ac94d0cc5ac"
    sha256 arm64_sonoma:  "c41043fa62904785fef70ec91f21b8cec8d354531ce041e0b70110abaee62ef3"
    sha256 arm64_ventura: "f22242fc590b91ffbd285026f6be195d7fab9058aea462dad08a363f376a904e"
    sha256 sonoma:        "c076c974706d412b64c9ccc718e9c6b765db3d383af66efbf5c3d5cf56cd3f83"
    sha256 ventura:       "50da0aa73a5230784093254c53813671b5d26251d08dbc318bb6c274e8fced0d"
    sha256 arm64_linux:   "08ebb2ed525bf867314e50544b0f7335d44a924694e7795d088502f0ac51e17c"
    sha256 x86_64_linux:  "0c305e258040d1bb2c4e8a4413bf59ed0f07ea62fd109c3a3c1ef4243d1a5894"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "python@3.13"
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
