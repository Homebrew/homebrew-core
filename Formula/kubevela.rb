class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v1.2.3",
      revision: "fbef61d07663c878ffabe5ac78c2423a8543628e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d42ff114a567b90e58c507673105b43f1431f3a2775ce6b07d9ad8f5bf7ae9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d42ff114a567b90e58c507673105b43f1431f3a2775ce6b07d9ad8f5bf7ae9a"
    sha256 cellar: :any_skip_relocation, monterey:       "522466d3b025dba7e1f5c3e71c27d261b17b53fa724f28afc04c5bc9f7f64976"
    sha256 cellar: :any_skip_relocation, big_sur:        "522466d3b025dba7e1f5c3e71c27d261b17b53fa724f28afc04c5bc9f7f64976"
    sha256 cellar: :any_skip_relocation, catalina:       "522466d3b025dba7e1f5c3e71c27d261b17b53fa724f28afc04c5bc9f7f64976"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b05d4af1351976a2aa3b7cffee9fdcc066230e776f8cbe768059675d242b061f"
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
    assert_match "Error: invalid configuration: no configuration", status_output

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
