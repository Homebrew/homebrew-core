class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.5.2",
      revision: "3df1776b375c281da56f449a1bd6474adf8aed40"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f072d5dac07f5cdeeca038ca2c3f04e87aab2d9a2ea42c7c18f5cc9cd1600e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f072d5dac07f5cdeeca038ca2c3f04e87aab2d9a2ea42c7c18f5cc9cd1600e5"
    sha256 cellar: :any_skip_relocation, monterey:       "3a606a5b0bc98fa34f421e4a9576be4aa38e9d081dd4799ae4a002b0a6fdb8f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a606a5b0bc98fa34f421e4a9576be4aa38e9d081dd4799ae4a002b0a6fdb8f7"
    sha256 cellar: :any_skip_relocation, catalina:       "3a606a5b0bc98fa34f421e4a9576be4aa38e9d081dd4799ae4a002b0a6fdb8f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1b0650d880e75ddc02f5cdf1eea20da6bf8bc86a94f541a6f5aaa877e892056"
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
