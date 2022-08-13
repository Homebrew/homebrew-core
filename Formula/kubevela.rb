class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.5.2",
      revision: "3df1776b375c281da56f449a1bd6474adf8aed40"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61d29e2b2efe403ce4aafc4b75a148a68113f6a5ca783749aa41a735f2db5797"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61d29e2b2efe403ce4aafc4b75a148a68113f6a5ca783749aa41a735f2db5797"
    sha256 cellar: :any_skip_relocation, monterey:       "5c660d85e76ba2a4441dcbca4d50379c96dc6bb28c68d65b7ef3249c6e57c997"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c660d85e76ba2a4441dcbca4d50379c96dc6bb28c68d65b7ef3249c6e57c997"
    sha256 cellar: :any_skip_relocation, catalina:       "5c660d85e76ba2a4441dcbca4d50379c96dc6bb28c68d65b7ef3249c6e57c997"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99a6a0e6aefda71199407ead45a6b2b106b7761b2287f48ae326aafd9dce13e3"
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
