class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.3.3",
      revision: "45e1de19dc736b10b3eb2d908d809210f470b24f"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cad332ae13671750a609b10b5c4b0cad36f6e715019023ebcad010123f721789"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cad332ae13671750a609b10b5c4b0cad36f6e715019023ebcad010123f721789"
    sha256 cellar: :any_skip_relocation, monterey:       "bbcca5ed1c5aeaec3453b9dd39ef8cf95467b3db64671bdb58062d4489869fd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbcca5ed1c5aeaec3453b9dd39ef8cf95467b3db64671bdb58062d4489869fd8"
    sha256 cellar: :any_skip_relocation, catalina:       "bbcca5ed1c5aeaec3453b9dd39ef8cf95467b3db64671bdb58062d4489869fd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0d4ec51b1bb48ce2d247ec1ad81d4f9e6cb9aa564d672d47d59e58a3da125ff"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/kubevela/kubevela/version.VelaVersion=#{version}
      -X github.com/kubevela/kubevela/version.GitRevision=#{Utils.git_head}
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
