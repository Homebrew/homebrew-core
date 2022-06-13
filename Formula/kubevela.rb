class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.4.2",
      revision: "eb9ddaabd35c4719329d39668bcd850487710de7"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd8c946fc3fafba9ed3a65e2ee8ba72420a2205f46fbc212378cac83705f8354"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd8c946fc3fafba9ed3a65e2ee8ba72420a2205f46fbc212378cac83705f8354"
    sha256 cellar: :any_skip_relocation, monterey:       "e40635066a3ab83a2b66f2e4bd7105454feef89b72db19c234dc9383c876d9c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "e40635066a3ab83a2b66f2e4bd7105454feef89b72db19c234dc9383c876d9c9"
    sha256 cellar: :any_skip_relocation, catalina:       "e40635066a3ab83a2b66f2e4bd7105454feef89b72db19c234dc9383c876d9c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e987502ea9b3d69a38a784d97c0e4d8c1d49b52a1b4335ddb3836fbba070f8ba"
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
