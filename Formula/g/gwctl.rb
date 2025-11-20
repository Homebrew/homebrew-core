class Gwctl < Formula
  desc "CLI for managing and inspecting Gateway API resources in Kubernetes clusters"
  homepage "https://github.com/kubernetes-sigs/gwctl"
  url "https://github.com/kubernetes-sigs/gwctl/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "07e300a95a9c2e8e88f96c8507e5acdc1e051f8b79125ee9c8174a06676ef655"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/gwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e532ca99c3da95393e97b339892130b0e12aca45c85ed3654e5291f948bbd740"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3914314844c5e36493c6b5d20241622e42ec0ef52ac72cfbd5bcc102a328c9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b388488f06cb1c253349fe72708d6e0ca8f12bad25253fd2df35fea04d2ed5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bf7cc7c350a7bb5e99b5eb36e2782d4159b3abb012daa771922fcf0831b4d01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5c806bf7a5be421ce61a498c8cfc5d3baaa7e6806556046fc1a8bc4786979b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "031872ef641d1f928e6b0e1e70e34f01943783535564f8ccc17df5562d1549a7"
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

    generate_completions_from_executable(bin/"gwctl", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gwctl version")

    output = shell_output("#{bin}/gwctl get gatewayclasses 2>&1", 1)
    assert_match "couldn't get current server API group list", output
  end
end
