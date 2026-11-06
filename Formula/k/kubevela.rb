class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.11.1",
      revision: "6552be81df471e35a612a5a0b3f38e5d6f944b02"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9ffd54135fa6fe6559de26f27bdc9a6359762a3589429a2bf90a55ca6b60c12c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ffd54135fa6fe6559de26f27bdc9a6359762a3589429a2bf90a55ca6b60c12c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9ffd54135fa6fe6559de26f27bdc9a6359762a3589429a2bf90a55ca6b60c12c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "66fc7077f89a6d81b8807a80ef3a7d81ae28336fd465b981bc09ba244c291958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c23706aade08b2dff6ceb27f2bab88d422b5971a008fcfc017a255a0c3e5490a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
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
