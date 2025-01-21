class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.9.13",
      revision: "d56da069eb5ee06d9716810e828d6370b93b70ba"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe1e54b93fe1283c9055ad8eeec23c03ae97e875551203c8e38b0e2667eda8c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe1e54b93fe1283c9055ad8eeec23c03ae97e875551203c8e38b0e2667eda8c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe1e54b93fe1283c9055ad8eeec23c03ae97e875551203c8e38b0e2667eda8c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "248c969a99ec3799628cf1a8213db0213199114c08cac51d5d6a91615812f876"
    sha256 cellar: :any_skip_relocation, ventura:       "248c969a99ec3799628cf1a8213db0213199114c08cac51d5d6a91615812f876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bf136e25f6812d38c07f3c8db51e5c80e0290d3df3adaf601c3423ff79664ad"
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
