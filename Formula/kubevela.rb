class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.4.8",
      revision: "192dc8966dbe897896467344d43cb5e93fd02660"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aae1c18557eb5385d1d448aa288a1967b3c8159b973b96abd076b270eb1fdf4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aae1c18557eb5385d1d448aa288a1967b3c8159b973b96abd076b270eb1fdf4b"
    sha256 cellar: :any_skip_relocation, monterey:       "70ade2ea2b1891c56757786180458586a2f9e9653e392a90f90e32e528561195"
    sha256 cellar: :any_skip_relocation, big_sur:        "70ade2ea2b1891c56757786180458586a2f9e9653e392a90f90e32e528561195"
    sha256 cellar: :any_skip_relocation, catalina:       "70ade2ea2b1891c56757786180458586a2f9e9653e392a90f90e32e528561195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "290d9f258acbbf229860328c50d39abf514d3f5d9501688067663ec4c3441f4b"
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
