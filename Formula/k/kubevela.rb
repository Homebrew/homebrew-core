class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.10.8",
      revision: "25473ac9fc1a980965cec80be1fc7c2f092c127a"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "faeb5b0f63de6a37570b340f0ca1ad99107d707f293d8eea9440a535ff4c999f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faeb5b0f63de6a37570b340f0ca1ad99107d707f293d8eea9440a535ff4c999f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "faeb5b0f63de6a37570b340f0ca1ad99107d707f293d8eea9440a535ff4c999f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f22a9d471e57c955e094355c0280c9fae796dd411aad8cd91513ef93302963e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1cd09d84da425205b6b930941b5d4f436e5a26468700074744c310d41723160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f620a6c63e1996a7a5132ac42fa6018eac2c9d80b82bf729e9941e18018415f5"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/oam-dev/kubevela/version.VelaVersion=#{version}
      -X github.com/oam-dev/kubevela/version.GitRevision=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(output: bin/"vela", ldflags:), "./references/cmd/cli"

    generate_completions_from_executable(bin/"vela", "completion", shells: [:bash, :zsh])
  end

  test do
    # Should error out as vela up need kubeconfig
    status_output = shell_output("#{bin}/vela up 2>&1", 1)
    assert_match "error: either app name or file should be set", status_output

    (testpath/"kube-config").write <<~YAML
      apiVersion: v1
      clusters:
      - cluster:
          certificate-authority-data: test
          server: http://127.0.0.1:8080
        name: test
      contexts:
      - context:
          cluster: test
          user: test
        name: test
      current-context: test
      kind: Config
      preferences: {}
      users:
      - name: test
        user:
          token: test
    YAML

    ENV["KUBECONFIG"] = testpath/"kube-config"
    version_output = shell_output("#{bin}/vela version 2>&1")
    assert_match "Version: #{version}", version_output
  end
end
