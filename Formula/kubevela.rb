class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.4.7",
      revision: "b596b70ebe2eb156d59d50b39ee6bb3f6b4e7da5"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ada70aba5ae14e21a70683c931ea407c60262f1757c504f39381474f141f3d03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ada70aba5ae14e21a70683c931ea407c60262f1757c504f39381474f141f3d03"
    sha256 cellar: :any_skip_relocation, monterey:       "6ef17401fb3341fde2d808563e923c5d25598646a48665ec23dc4757f088ecee"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ef17401fb3341fde2d808563e923c5d25598646a48665ec23dc4757f088ecee"
    sha256 cellar: :any_skip_relocation, catalina:       "6ef17401fb3341fde2d808563e923c5d25598646a48665ec23dc4757f088ecee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "895f2464ec3dd44ffbe2233482e325ccbfdbac4bbc2a6241f64c101feb775ab8"
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
