class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v1.2.3",
      revision: "fbef61d07663c878ffabe5ac78c2423a8543628e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17ba8271e4742c51e86541e94782dcca84a079733f58df7505b047b4f30c93b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17ba8271e4742c51e86541e94782dcca84a079733f58df7505b047b4f30c93b5"
    sha256 cellar: :any_skip_relocation, monterey:       "a6885762c1594b6b518df8253e6c2f3089cc57dba8fc4fc0a7c73430ef6d9809"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6885762c1594b6b518df8253e6c2f3089cc57dba8fc4fc0a7c73430ef6d9809"
    sha256 cellar: :any_skip_relocation, catalina:       "a6885762c1594b6b518df8253e6c2f3089cc57dba8fc4fc0a7c73430ef6d9809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "badeadf0455c15caa1b82f3edba7d65fd56ff9a9a44113633296b7b655eb9717"
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
