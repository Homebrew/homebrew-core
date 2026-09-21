class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://github.com/navidrome/navidrome/archive/refs/tags/v0.64.0.tar.gz"
  sha256 "0f395ee2672d32eed9da9ad6b16ec21d1a270d3ba5299fd638ddca237db5fa4c"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "07fa928a0933be79b8252668eb94735f40c7da169130f8c3856f619d6bab679c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0ac8fa8b4ccdfcfbc35f8b6a78bc75665804a13d1ab377038f354d1315dce51c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d916c58b6878bf3fdd34dd83033ffabc9e3b3190def468fa6cd80c9fb560cf92"
    sha256 cellar: :any,                 arm64_linux:       "d00f536ff47bbc9f8c69728758e22992fedd1943082add4108e0b06aa91f4410"
    sha256 cellar: :any,                 x86_64_linux:      "b585894984028fe847896b525e595c1b6bd891696828aae8b8850254a1d7f99c"
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
    assert_equal ".", shell_output("curl http://localhost:#{port}/ping")
  ensure
    Process.kill "KILL", pid
    Process.wait pid
  end
end
