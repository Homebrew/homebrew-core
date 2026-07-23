class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.11.0",
      revision: "a1860544f0556828e165ef68701b2926730671a7"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1da421dd9805aa03e28bd3cc04d5b7457201c1247e88cabca303dba574efecc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1da421dd9805aa03e28bd3cc04d5b7457201c1247e88cabca303dba574efecc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1da421dd9805aa03e28bd3cc04d5b7457201c1247e88cabca303dba574efecc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5911ff4f6043b697b6642b87c30d8816dd232a2bf9709885d57fd37198eed110"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74bf4c2db0bf524b0692c073c6903366ea80a1147a87611ad4296149d5032d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f6e0c0810ff9c97596622e63e59ae10f8b51104056f266bb426fe20d0c9b7f4"
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
