class Draft < Formula
  desc "Day 0 tool for getting your app on Kubernetes fast"
  homepage "https://github.com/Azure/draft"
  url "https://github.com/Azure/draft/archive/refs/tags/v0.17.17.tar.gz"
  sha256 "02417432eaa374505829ea2e8d80655f5555436a5f3b737dca1fa19a8e570026"
  license "MIT"
  head "https://github.com/Azure/draft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "65e13fa31e68f6a6c717f128888468c152444758cdfdd1be368c839c78a32c42"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ae7fd37d0b78b09c242df73a0ca7d01a315ab166aca2ad98cfee248e89127b53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f64fff3811ddf36a8982681e841d02da00e9cf174a6b3a20a47dd2742ed76696"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eb8258843dc2120d19b4828a63a00143e1ac8716e968deed2fb2d74ff826a9cf"
    sha256 cellar: :any,                 x86_64_linux:      "86dbb2a3c136387475e5cb796d5daa51cf2548cb9ae4e6abeb3b28a035491a52"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/Azure/draft/cmd.VERSION=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"draft", shell_parameter_format: :cobra)
  end

  test do
    supported_deployment_types = JSON.parse(shell_output("#{bin}/draft info"))["supportedDeploymentTypes"]
    assert_equal ["helm", "kustomize", "manifests"], supported_deployment_types

    assert_match version.to_s, shell_output("#{bin}/draft version")
  end
end
