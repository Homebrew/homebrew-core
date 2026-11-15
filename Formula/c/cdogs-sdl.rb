class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://github.com/cxong/cdogs-sdl/archive/refs/tags/2.5.0.tar.gz"
  sha256 "18b594e85af9986b7e895aba0f72de05bdf0c73c808653ecd004c45c1842f147"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "29ac580f02f3d0e16d6dcf9d6c2ef37b46355fa3ccfa893e19deef6bc3b7e56f"
    sha256 arm64_tahoe:       "d1fc8dd530aba51aa4e0742a693d2db6f23316bbf20b0b4a24f52610c33fe7a5"
    sha256 arm64_sequoia:     "81a7827460102dafa2184473f7ffbeb1354792d2e8dd52d5d577864c7f2ca065"
    sha256 arm64_linux:       "b65116fa72e04c5e8cd953f0174ba8c114f810968abf36f9fe3b3637dec48728"
    sha256 x86_64_linux:      "8b4807dde80c7d4e6d30882cb98dde9ce52b71d3bde183af765e0f179910f3f7"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "sdl2-compat"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  uses_from_macos "python"

  on_linux do
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "mesa"
  end

  deny_network_access!

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
