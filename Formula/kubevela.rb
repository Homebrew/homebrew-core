class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v1.2.5",
      revision: "ef80b6617ec915b8cce269bcd99415b9795f4747"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d8a517511311eac0379d74d4e2d6c6119763fc731abe57f3dad4434493abbd8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d8a517511311eac0379d74d4e2d6c6119763fc731abe57f3dad4434493abbd8"
    sha256 cellar: :any_skip_relocation, monterey:       "e1e1c1c8b64fe224b93170f88c82b1e1a4754d347bd86a6a35142e97b0962b6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1e1c1c8b64fe224b93170f88c82b1e1a4754d347bd86a6a35142e97b0962b6f"
    sha256 cellar: :any_skip_relocation, catalina:       "e1e1c1c8b64fe224b93170f88c82b1e1a4754d347bd86a6a35142e97b0962b6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eb05f15de70587b776c18d40e9fa9957a9bef4ffe4446ea3855fa20c8b48e46"
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
