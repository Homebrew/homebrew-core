class JiraCli < Formula
  desc "Feature-rich interactive Jira CLI"
  homepage "https://github.com/ankitpokhrel/jira-cli"
  url "https://github.com/ankitpokhrel/jira-cli/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "6b1ecbd2228626cdc987548d8d83faae074c7a167cef737a9ac9180a03767154"
  license "MIT"
  head "https://github.com/ankitpokhrel/jira-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83bde3e196ac3281f1a71331661523f60660a8a0b701f7d0560fd81d74fdafb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2091e947050eba96546cfde048c686b091d3328caa65afca1a9b7de37214f3bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9d1e532994bcfd60fa12afe7d83ec71dde725dd18cd940bedb6fbfbb38c27b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d7b5290b6d360703c1a6826dff5475c4de3e753e0557e0a99096aabb34be985"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81792d7e9c0f92c7dcb173d5b1b27dfa33bb601eaf7141b465ee448ccf5f2f78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8e64de223d45f2f26f426531e6625ce7a375e6b9a7754a9803d79de32bf7298"
  end

  depends_on "go" => :build

  conflicts_with "go-jira", because: "both install `jira` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/ankitpokhrel/jira-cli/internal/version.Version=#{version}
      -X github.com/ankitpokhrel/jira-cli/internal/version.GitCommit=#{tap.user}
      -X github.com/ankitpokhrel/jira-cli/internal/version.SourceDateEpoch=#{time.to_i}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"jira"), "./cmd/jira"

    generate_completions_from_executable(bin/"jira", shell_parameter_format: :cobra)
    (man7/"jira.7").write Utils.safe_popen_read(bin/"jira", "man")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jira version")

    output = shell_output("#{bin}/jira serverinfo 2>&1", 1)
    assert_match "The tool needs a Jira API token to function", output
  end
end
