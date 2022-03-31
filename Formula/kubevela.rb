class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v1.3.0",
      revision: "3aa4412a0f7023fda2625a07ffea2747b215c850"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f1e4b410fb1c17a17bb249720078a842ed2b8ffae522334d5dbbb523bcd5242"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f1e4b410fb1c17a17bb249720078a842ed2b8ffae522334d5dbbb523bcd5242"
    sha256 cellar: :any_skip_relocation, monterey:       "0b7b7b6226db37100b4c23abf4378a718750c65f9f68745b6dc0d6b1fbc2cef4"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b7b7b6226db37100b4c23abf4378a718750c65f9f68745b6dc0d6b1fbc2cef4"
    sha256 cellar: :any_skip_relocation, catalina:       "0b7b7b6226db37100b4c23abf4378a718750c65f9f68745b6dc0d6b1fbc2cef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ee7cdcea7e72ce1b2db1798fccac0fd1389d551c7391ff5852834a91b0c1d8e"
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
