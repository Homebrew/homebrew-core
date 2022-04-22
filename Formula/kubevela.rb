class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v1.3.2",
      revision: "d08aa7d12c8a3d130a2428b25fd75cf30ed23b25"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19cd7e9775d946d2a724af9f48e7f1398ceda4e729bada63b17b7339aed77cc8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19cd7e9775d946d2a724af9f48e7f1398ceda4e729bada63b17b7339aed77cc8"
    sha256 cellar: :any_skip_relocation, monterey:       "785a4b40990351d59db2fe0875ed6219c3dd51d1b7884bd069642b14b058f67e"
    sha256 cellar: :any_skip_relocation, big_sur:        "785a4b40990351d59db2fe0875ed6219c3dd51d1b7884bd069642b14b058f67e"
    sha256 cellar: :any_skip_relocation, catalina:       "785a4b40990351d59db2fe0875ed6219c3dd51d1b7884bd069642b14b058f67e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01b890ef531a48dc9a8b933449ee59488f77ae2315d4c524c858428aa642f514"
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
