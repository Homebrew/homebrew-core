class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.4.2",
      revision: "eb9ddaabd35c4719329d39668bcd850487710de7"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3090296b7ccd62e3aeca614ce7b3147e06c099e1d6f3d2fb37085af5776d5d7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3090296b7ccd62e3aeca614ce7b3147e06c099e1d6f3d2fb37085af5776d5d7b"
    sha256 cellar: :any_skip_relocation, monterey:       "1669adfa599426bc29868c4365e2b2e49165e37560798d36ddf43df849495706"
    sha256 cellar: :any_skip_relocation, big_sur:        "1669adfa599426bc29868c4365e2b2e49165e37560798d36ddf43df849495706"
    sha256 cellar: :any_skip_relocation, catalina:       "1669adfa599426bc29868c4365e2b2e49165e37560798d36ddf43df849495706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e92986c595c642ac78d116433d5f6ae4c09cee07dd36fc5aa5812354e6f0d96"
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
