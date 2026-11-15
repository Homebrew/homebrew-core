class Navidrome < Formula
  desc "Modern Music Server and Streamer compatible with Subsonic/Airsonic"
  homepage "https://www.navidrome.org"
  url "https://github.com/navidrome/navidrome/archive/refs/tags/v0.64.2.tar.gz"
  sha256 "6d6de86c7509620dd445be9c22f2441225c9d86f009317c9b92923ad3a83ddb5"
  license "GPL-3.0-only"
  head "https://github.com/navidrome/navidrome.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a9d62ee244f4df3a9b0cd71d76b6c58add98c95128cccbaf7a0896057209c041"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b165e1886d4ccbb903f7e0f6dd6fd8df900d0bac885631a51a5f362c7782b58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "70a4927cca0d766152bc82042acaefc5a291579e26328ba7e74fbfb80becd1fe"
    sha256 cellar: :any,                 arm64_linux:       "159c0870021ca45c17866b4da37e442c66b8d017f86305b9c9818455f5eb2f74"
    sha256 cellar: :any,                 x86_64_linux:      "7423d70b09628d85e9fb798a9fed0341a602ec2b43c23aca92de0ee916e26880"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "taglib"

  def install
    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arm64?
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
