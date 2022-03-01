class BuildpulseTestReporter < Formula
  desc "Connect your CI to BuildPulse to detect, track, and rank flaky tests"
  homepage "https://buildpulse.io"
  url "https://github.com/buildpulse/test-reporter/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "ddf899694f17c072822191a1294c6968ab0992c1ce7bbd1318a148fbad497704"
  license "MIT"
  head "https://github.com/buildpulse/test-reporter.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc606c6d83f038ebd5c9cc520e506e089e913bc9a36d2128448ade814235ea04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a87bf88d81b0d429fa8eeaefd0300b81b9c10cbcac40dae53b1b6c2035e6c35"
    sha256 cellar: :any_skip_relocation, monterey:       "dd79a8d93b12fa01f8aa0ff569cd4e19963e84cf2b63675bf12dada26c7a3292"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b85c38b675bd8a4a6067b7ff9c30fb8301fe449a4bf2a29d13a126ac76c79ba"
    sha256 cellar: :any_skip_relocation, catalina:       "18c6e6e67d8565d40ea892ce05a5aa16be9e7e862fcb7fc9db58077a89612667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e623752ac450388876d922c1dafe4f3e6d3458d2f1e5d802f94b65afa4923733"
  end

  depends_on "go" => :build

  def install
    goldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: goldflags), "./cmd/test-reporter"
  end

  test do
    binary = bin/"buildpulse-test-reporter"
    assert_match version.to_s, shell_output("#{binary} --version")

    fake_dir = "im-not-real"
    assert_match "Received args: #{fake_dir}", shell_output("#{binary} submit #{fake_dir}", 1)
  end
end
