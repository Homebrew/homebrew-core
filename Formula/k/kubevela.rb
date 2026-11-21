class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.11.2",
      revision: "6b09de2813dd9909b39ae8b0820768e194bf4da2"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    manifest_sha256 "65fbd299d5df047e113318cb2a4aed88b4d51e96321409fb3ab469d08464d072"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b652bc9cd2725e551505e2f90307f888320074823f37668c39dce8714fddee5d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b652bc9cd2725e551505e2f90307f888320074823f37668c39dce8714fddee5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b652bc9cd2725e551505e2f90307f888320074823f37668c39dce8714fddee5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "919ccb168ae450280065ac7e2fce70f2fa5393e01be50df21763d43bd958a095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "dcc2c0181a929f8e1c53909394db606da96693209cac51069ce8fd87a2d3cb25"
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
