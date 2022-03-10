class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v1.2.5",
      revision: "ef80b6617ec915b8cce269bcd99415b9795f4747"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ba9fce20574e58f583993a3cdb84be842e7b2ad5dd50daef993f7ccf59508fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ba9fce20574e58f583993a3cdb84be842e7b2ad5dd50daef993f7ccf59508fb"
    sha256 cellar: :any_skip_relocation, monterey:       "cf958ccc0fbdea9ec1a04544d4b293e10b2aafe367ae134420b5efef5103b739"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf958ccc0fbdea9ec1a04544d4b293e10b2aafe367ae134420b5efef5103b739"
    sha256 cellar: :any_skip_relocation, catalina:       "cf958ccc0fbdea9ec1a04544d4b293e10b2aafe367ae134420b5efef5103b739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40601810ae5fe1f510a85a5b71440b5126930d44769e251ea2fd27e698cb6e8e"
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
