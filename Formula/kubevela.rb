class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.3.5",
      revision: "cbed2b5cb3371b48357dbda3b5fc278a506c4d70"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff321dd00b5111be9e4fb9fdc70803c8e1684077c33ee7a59b78c6133e18ed4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff321dd00b5111be9e4fb9fdc70803c8e1684077c33ee7a59b78c6133e18ed4e"
    sha256 cellar: :any_skip_relocation, monterey:       "f815f5849b232dfe0538793172499274667b0cc23dfb5f063759dfc99bd35c27"
    sha256 cellar: :any_skip_relocation, big_sur:        "f815f5849b232dfe0538793172499274667b0cc23dfb5f063759dfc99bd35c27"
    sha256 cellar: :any_skip_relocation, catalina:       "f815f5849b232dfe0538793172499274667b0cc23dfb5f063759dfc99bd35c27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17e68b0f3ffd4635906bda8cb6ffa57a6773357c1ddde254813f224e9c381771"
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
