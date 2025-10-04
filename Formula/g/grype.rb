class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.100.0.tar.gz"
  sha256 "695f9fe9b446a5cd7fbe85510279a8a7513bfe840beb96334c8540871bab7cbd"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9977777b6fddf6b1d0fb6d3c55b5ea34c6f8bb80894805d2026f591e45ef3eb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fdcfb0de261b70ac073a4eeaed6c3165fec942b18f408dea7b551a5d9e6ae92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "725d3199d423fe6cbd7fa8cb095ecf686715dd1cf6cda6e33b81f6e30e6fbaa2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f737ce42d4bfea1374081769bf321778dac502733f432b6d55edea4336d7ccb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bd9023fe58a58aeba721771fbe80c4a2811d095c4d8f28657d95f2027d0b4b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b591bd18cfdc75646ec82cbef57871ee4e43b5534c8ce6e865751c72dbb2dad"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end
