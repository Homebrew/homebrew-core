class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.3.5",
      revision: "cbed2b5cb3371b48357dbda3b5fc278a506c4d70"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e9d86c212cff4f384810934cbb0df53ef41e23cfb92c1e3ed38a7f977913f18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e9d86c212cff4f384810934cbb0df53ef41e23cfb92c1e3ed38a7f977913f18"
    sha256 cellar: :any_skip_relocation, monterey:       "4f8870b53bf921f69988d74988c2a89cc9e70a109c0f533f0fd40f7221e2eead"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f8870b53bf921f69988d74988c2a89cc9e70a109c0f533f0fd40f7221e2eead"
    sha256 cellar: :any_skip_relocation, catalina:       "4f8870b53bf921f69988d74988c2a89cc9e70a109c0f533f0fd40f7221e2eead"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c2efda33babe6348f619cab8cfda097a3e4c3ff1b12eb819c036b58c9f9c680"
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
