class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://github.com/navidrome/navidrome/archive/refs/tags/v0.63.0.tar.gz"
  sha256 "46ee8475b7e144744092ba353b2e6ce0f000537c4e985551a14bd2c5b2dd3ab4"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ba3ff4e5f20229109559beb50338c8616f7e45a6f2e1ab61c80cd5d2574891a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f60025535bdc1019259e14769eac84e8158921529528de2a993c53caa9d89c5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91d809a1117c1f42805b8cab607ef4eac7101ecd9f80c8deccacac396c0ef23e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d842f27638d93751be6ee434e67d56d1efecbf2b90419c3a0222fcad534b277c"
    sha256 cellar: :any,                 arm64_linux:   "140736aa3061dbf1ca62848836442042730b2463cde89740beb40f58d595e1e9"
    sha256 cellar: :any,                 x86_64_linux:  "ed47b0cc84cd0a3fb51323c055f5ff87cef41c92c24f30652f367bfd82cbd724"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "taglib"

  def install
    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = %W[
      -s -w
      -X github.com/navidrome/navidrome/consts.gitTag=v#{version}
      -X github.com/navidrome/navidrome/consts.gitSha=source_archive
    ]

    system "make", "setup"
    system "make", "buildjs"
    system "go", "build", *std_go_args(ldflags:, tags: "netgo,sqlite_fts5"), "-buildvcs=false"

    generate_completions_from_executable(bin/"navidrome", shell_parameter_format: :cobra)
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
