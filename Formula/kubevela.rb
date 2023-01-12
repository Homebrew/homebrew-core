class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.6.7",
      revision: "b11eb845b28ee2176c9aaf32a6a4d8af2f62b06e"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e01ec69a89fcb3d309949aa8652683dde1cbb7ebe11eb5231da2dcb3400f5d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e01ec69a89fcb3d309949aa8652683dde1cbb7ebe11eb5231da2dcb3400f5d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e01ec69a89fcb3d309949aa8652683dde1cbb7ebe11eb5231da2dcb3400f5d2"
    sha256 cellar: :any_skip_relocation, ventura:        "54267f6357249f6430c25b757af3be3aacbd7515cf22f70e69538efef9f311e4"
    sha256 cellar: :any_skip_relocation, monterey:       "54267f6357249f6430c25b757af3be3aacbd7515cf22f70e69538efef9f311e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "54267f6357249f6430c25b757af3be3aacbd7515cf22f70e69538efef9f311e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0307f907df083eb5515dd9dc4d3542ab57cec0f49c5fddad28251ad1fba29d1"
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
