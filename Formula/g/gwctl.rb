class Gwctl < Formula
  desc "CLI for managing and inspecting Gateway API resources in Kubernetes clusters"
  homepage "https://github.com/kubernetes-sigs/gwctl"
  url "https://github.com/kubernetes-sigs/gwctl/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ee3bf78df7645f518db0adc21aa156507847c4f0727eb949d7d49c8aa8cb9c73"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/gwctl.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efbf9a8653386ffd5de1672d8a2c537b4f4068ad8c2dae1f56bfb95564ed7b1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68779cf2b96309d2e1c5f208ae3a1dbd73bd04880e8eabfaa662c0eccc23969d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82a0859de3946d031f2fe58d311dc274bb017db8aa2969250ca22cf648e49b07"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5ba3ab0c7b9434cd9f8262076fc135f33931c6cd42efd6fa6904737bfb70d7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "943bcc5c3a2fe743b4cc4f68e9b0e97000d8f86bb8b983530a9635e2b43f5da6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6287626230449f478eca11da68ede7fb7e75b202216f6ecf59405f5f9ba1e6fa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/gwctl/pkg/version.version=#{version}
      -X sigs.k8s.io/gwctl/pkg/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/gwctl/pkg/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gwctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gwctl version")

    output = shell_output("#{bin}/gwctl get gatewayclasses 2>&1", 1)
    assert_match "couldn't get current server API group list", output
  end
end
