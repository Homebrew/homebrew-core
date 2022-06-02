class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.4.1",
      revision: "ea0508a634f7d76731f062e034feea8b75f74be1"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a58b8c247fbddd80a3eb628e65041b77edc4eb1a1af488d6a492c501e06c95f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a58b8c247fbddd80a3eb628e65041b77edc4eb1a1af488d6a492c501e06c95f"
    sha256 cellar: :any_skip_relocation, monterey:       "23b607cd2d78c4573be5d3492a48fd328e10dad782790e8be6d865b394804339"
    sha256 cellar: :any_skip_relocation, big_sur:        "23b607cd2d78c4573be5d3492a48fd328e10dad782790e8be6d865b394804339"
    sha256 cellar: :any_skip_relocation, catalina:       "23b607cd2d78c4573be5d3492a48fd328e10dad782790e8be6d865b394804339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de90ff1cf98ba3853724c49ae7788a4c3cb50270ca825b295420413b786096f2"
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
