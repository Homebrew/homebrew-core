class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://github.com/navidrome/navidrome/archive/refs/tags/v0.55.2.tar.gz"
  sha256 "bdc609bca68531190bac7591b9ba14b3aed356c989087803f16c2d888a8878a8"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e4253eb9086dc0ab26cbc6c0e1affbc1feacfe69679c2bf2bcea9f3d67e2e22d"
    sha256 cellar: :any,                 arm64_sonoma:  "bf31eb52e348146caf5e0352a8de412a16023a0fa8d57b5eaa2dd36784a43677"
    sha256 cellar: :any,                 arm64_ventura: "eba8fc0b55cfdae27cbb1f390f6e625947374d7fb6c92c7b10fb282eaa7612f0"
    sha256 cellar: :any,                 sonoma:        "525a5fe97f039722515d3100f14af57196037db3648ace6a8b07407b65bb95f7"
    sha256 cellar: :any,                 ventura:       "d0ed9c8dfe3749fc0cf6635c9bfa8dac7c53ac52940ac5bd2d50028a2b2c3274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe065d7c8c4602d973e22d1066047a4ecafc4e7a57742bb8bd812a0079ccc209"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "taglib"

  def install
    ldflags = %W[
      -s -w
      -X github.com/navidrome/navidrome/consts.gitTag=v#{version}
      -X github.com/navidrome/navidrome/consts.gitSha=source_archive
    ]

    system "make", "setup"
    system "make", "buildjs"
    system "go", "build", *std_go_args(ldflags:, tags: "netgo"), "-buildvcs=false"
  end

  test do
    assert_equal "#{version} (source_archive)", shell_output("#{bin}/navidrome --version").chomp
    port = free_port
    pid = spawn bin/"navidrome", "--port", port.to_s
    sleep 20
    sleep 100 if OS.mac? && Hardware::CPU.intel?
    assert_equal ".", shell_output("curl http://localhost:#{port}/ping")
  ensure
    Process.kill "KILL", pid
    Process.wait pid
  end
end
