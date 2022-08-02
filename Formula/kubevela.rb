class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.4.9",
      revision: "766c5852c6b60a0b1942037e35e10f99deb8dfbe"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98ae5abe3b1b8fb1620adb8770caa3dfc2b162e5891608452047d2e3630976ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98ae5abe3b1b8fb1620adb8770caa3dfc2b162e5891608452047d2e3630976ec"
    sha256 cellar: :any_skip_relocation, monterey:       "b7a45066700ee6b46d5538f3de5344f6f511a453608e2fec2bcd83400bb64610"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7a45066700ee6b46d5538f3de5344f6f511a453608e2fec2bcd83400bb64610"
    sha256 cellar: :any_skip_relocation, catalina:       "b7a45066700ee6b46d5538f3de5344f6f511a453608e2fec2bcd83400bb64610"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7c88ae81ff0522164995a414f6c9669b36a7d694178143f76eeb4424a822de4"
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
