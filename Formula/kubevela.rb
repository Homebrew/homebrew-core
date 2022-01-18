class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v1.2.1",
      revision: "12f392cd922e0333b2d15b0a477dc1a39683841e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "757373020f2e78d4989dce741075e24d52900f7d8200472749deb91a874ab819"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "757373020f2e78d4989dce741075e24d52900f7d8200472749deb91a874ab819"
    sha256 cellar: :any_skip_relocation, monterey:       "a30f09d2a5aa3376bdb8d46f892fda3d43aa92a0d6960edb3c81eea3e459bbd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a30f09d2a5aa3376bdb8d46f892fda3d43aa92a0d6960edb3c81eea3e459bbd9"
    sha256 cellar: :any_skip_relocation, catalina:       "a30f09d2a5aa3376bdb8d46f892fda3d43aa92a0d6960edb3c81eea3e459bbd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67585735c06ab373633faa339370a168f3615c6caf9a3b173bb24134f8ca0cb3"
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
