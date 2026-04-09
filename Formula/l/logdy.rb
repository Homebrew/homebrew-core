class Logdy < Formula
  desc "Web based real-time log viewer"
  homepage "https://logdy.dev"
  url "https://github.com/logdyhq/logdy-core/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "bd5db124e736e42d3671697787a26b354e0be6e787a95e69c054ad873058fcec"
  license "Apache-2.0"
  head "https://github.com/logdyhq/logdy-core.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53f402762567926f939ba76f3f885f54828264dc2c160c6d5bcf46f8afe49227"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53f402762567926f939ba76f3f885f54828264dc2c160c6d5bcf46f8afe49227"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53f402762567926f939ba76f3f885f54828264dc2c160c6d5bcf46f8afe49227"
    sha256 cellar: :any_skip_relocation, sonoma:        "f77f84e02e77364a615b9aa0c20abe11e759944c4398b4b886fb2dc0766f8a72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4251ec939cfdb8640b16d3c2a1f0a1c8a8afe46a84f5630936470b0ff4e9caf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "164bd9fef16faca0f6a3d14b38a72c63127c1b7a8c4739428e2aba731265b3bc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"logdy", shell_parameter_format: :cobra)
  end

  test do
    port = free_port
    r, _, pid = PTY.spawn("#{bin}/logdy stdin --port=#{port}")
    assert_match "Listen to stdin (from pipe)", r.readline
  ensure
    Process.kill("TERM", pid)
  end
end
