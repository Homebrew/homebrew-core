class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "v0.231.0",
      revision: "f671416a1ca0f8eb407dd0056de22044283926b2"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a8a182e9644298c2d1e633e14303705cbea402866512fd4840bff6350b8a3b10"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d1793ce732f49d2a76a3acb659faf8be551e49d847e1885dde3943dc8b1491ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b1945f74d6c24eb2f93a83bb8753cfcf6595a0d665eaa69a784e9a244db67ba4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3f7130236713c29cc8c2215719b466f1bb693b2feb6d097ada426622aad420bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f0f021f674af45047a705b2f515e8e4e5b659e5864e9f1e450bfb5904ae36102"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "make", "binary"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
