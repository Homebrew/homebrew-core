class Gwctl < Formula
  desc "CLI for managing and inspecting Gateway API resources in Kubernetes clusters"
  homepage "https://github.com/kubernetes-sigs/gwctl"
  url "https://github.com/kubernetes-sigs/gwctl/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ee3bf78df7645f518db0adc21aa156507847c4f0727eb949d7d49c8aa8cb9c73"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/gwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "faa742bfec4360e204f5b31ba843338c797ed1202fcebbb8467b32d402d75d45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9be86c2468c1a3b0bba1428552377f20d67c8ad80b18f557209a2714151ad9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a15101ce4a58c3922c4535ccc8979650adfb4b40978eb872841ae9b21735cfee"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6e3436fd5a6d0935f9ca6ae9583c162ae5a28ff316f9d1e6d344faab3b95224"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b5d9a5014676ca1949262775e1e71b8f67bbe8d7e60e77eb8bde5d92ed730ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c9020e87b2c86afcc05dbc8923d14f847bf1e807a8a3a3778bc015c559d216b"
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
