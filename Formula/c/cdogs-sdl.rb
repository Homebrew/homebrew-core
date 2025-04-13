class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/refs/tags/2.3.0.tar.gz"
  sha256 "6ea66e058503a5c160dbeccc25072061c87e190ced6876ae5b63a3e4d1ed0044"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "08a30a5c543e87a3124a15c907b73060fe443820bbd6565569f49fb33541639d"
    sha256 arm64_sonoma:  "c5a53c5b4fb1d8872f8df040958878bf133c7ef335111e31782c353a0b846c07"
    sha256 arm64_ventura: "9d525e0b2132b29d012dd04fa065bf67a0424dba356c112e80370cc65e4fa446"
    sha256 sonoma:        "f49ea1edd7342d5645cf54b49c0a07f4116df52c86d357c966d304615f4afc90"
    sha256 ventura:       "1a60efaeb8e6680ff86ba951abf2ff25078a0e4fc6c6dcada978f547b85694e3"
    sha256 arm64_linux:   "bf9707f098bb504f6ce1bb5d0b597e6325a68229a5e9fc8de9e6fe634f9d44eb"
    sha256 x86_64_linux:  "6eed5b0c3979d10ba041c7755640461247e63979d6287fde09554dd712ec151e"
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
