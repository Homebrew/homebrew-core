class HarborCli < Formula
  desc "CLI for Harbor container registry"
  homepage "https://github.com/goharbor/harbor-cli"
  url "https://github.com/goharbor/harbor-cli/archive/refs/tags/v0.0.19.tar.gz"
  sha256 "3c8b9e48f14712f9e4c2179fa59c7b391fe904017c3bfa584d1e868af55aa61a"
  license "Apache-2.0"
  head "https://github.com/goharbor/harbor-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8812b8ec9c90bc422293942c66b749fe40b474123189a3cb00d6b5e8e2d20519"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8812b8ec9c90bc422293942c66b749fe40b474123189a3cb00d6b5e8e2d20519"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8812b8ec9c90bc422293942c66b749fe40b474123189a3cb00d6b5e8e2d20519"
    sha256 cellar: :any_skip_relocation, sonoma:        "f277d74af7da81de12e8b82d96548420a1b46b8c2b95f5b581dc2c02ef56b2c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d99b5f110946d17f3cdae55d62b03f89a2864f732680795a6d12a6e0ab10411d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e4fa5a1650cbc9e7f21e86a2eabaef259d62fb50693ecd01855fe981ad63970"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.Version=#{version}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.GoVersion=#{Formula["go"].version}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.GitCommit=#{tap.user}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"harbor"), "./cmd/harbor"

    generate_completions_from_executable(bin/"harbor", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/harbor version")

    output = shell_output("#{bin}/harbor repo list 2>&1", 1)
    assert_match "Error: failed to get project name", output
  end
end
