class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.7.6",
      revision: "e4cd1ffd1d4006fd297aeb68a37c5f3a6ec09a4f"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2417aef305b993cb75a7aa0a39fcd9b9aaabb5bb07d62e85635c564f8ee617c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2417aef305b993cb75a7aa0a39fcd9b9aaabb5bb07d62e85635c564f8ee617c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2417aef305b993cb75a7aa0a39fcd9b9aaabb5bb07d62e85635c564f8ee617c"
    sha256 cellar: :any_skip_relocation, ventura:        "5797380a603480f7e20b264f95408c6a125cd70265308bb1bb358e0e497cd73a"
    sha256 cellar: :any_skip_relocation, monterey:       "5797380a603480f7e20b264f95408c6a125cd70265308bb1bb358e0e497cd73a"
    sha256 cellar: :any_skip_relocation, big_sur:        "5797380a603480f7e20b264f95408c6a125cd70265308bb1bb358e0e497cd73a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "272f4ba3888e1976109032c0a376b21725762891934af3dae27cc66eea08b110"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/oam-dev/kubevela/version.VelaVersion=#{version}
      -X github.com/oam-dev/kubevela/version.GitRevision=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(output: bin/"vela", ldflags: ldflags), "./references/cmd/cli"

    generate_completions_from_executable(bin/"vela", "completion", shells: [:bash, :zsh], base_name: "vela")
  end

  test do
    # Should error out as vela up need kubeconfig
    status_output = shell_output("#{bin}/vela up 2>&1", 1)
    assert_match "error: no configuration has been provided", status_output

    (testpath/"kube-config").write <<~EOS
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
    EOS

    ENV["KUBECONFIG"] = testpath/"kube-config"
    version_output = shell_output("#{bin}/vela version 2>&1")
    assert_match "Version: #{version}", version_output
  end
end
