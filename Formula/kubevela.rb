class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.5.0",
      revision: "e29b1af20288d25f5addb268fef83fe21fd1f689"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5b0a9d72f22321fae8ec043317a8dbbaeef15f5b713638a9c4e50f07082ab92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5b0a9d72f22321fae8ec043317a8dbbaeef15f5b713638a9c4e50f07082ab92"
    sha256 cellar: :any_skip_relocation, monterey:       "3dc6ca5ea61bc483105364b1a3a68a9baebe698c8f82829f59200762e761a302"
    sha256 cellar: :any_skip_relocation, big_sur:        "3dc6ca5ea61bc483105364b1a3a68a9baebe698c8f82829f59200762e761a302"
    sha256 cellar: :any_skip_relocation, catalina:       "3dc6ca5ea61bc483105364b1a3a68a9baebe698c8f82829f59200762e761a302"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4a1d10a0ddc702489efb1118fe48c09ef0360a50e3e68f1344aa8e40ed6734b"
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
