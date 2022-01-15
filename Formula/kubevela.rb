class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v1.2.0",
      revision: "6cee4687437958cbaa34e41112c8a1734503ec3c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "602a65c3c65bad6ff6f46fc28e67b2876ca047d296d9f2a4a370b080a8985267"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "602a65c3c65bad6ff6f46fc28e67b2876ca047d296d9f2a4a370b080a8985267"
    sha256 cellar: :any_skip_relocation, monterey:       "d78cd27a1e249e683701f2c2353a3270f48e81c224add7891f9545272b599ea2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d78cd27a1e249e683701f2c2353a3270f48e81c224add7891f9545272b599ea2"
    sha256 cellar: :any_skip_relocation, catalina:       "d78cd27a1e249e683701f2c2353a3270f48e81c224add7891f9545272b599ea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6471e50591bcd900a57974c4af8bfc8f5d99504caf5e75d57003241c13670467"
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
