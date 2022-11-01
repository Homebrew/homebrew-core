class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.6.0",
      revision: "4b4e4f8530fe9ecac9e7f3b7bf64d8cb9c792c1e"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b910b8b596892d7dcef2b6bf15bbba4d9e7c996fb22bbbc0255b3d2b7594967c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b910b8b596892d7dcef2b6bf15bbba4d9e7c996fb22bbbc0255b3d2b7594967c"
    sha256 cellar: :any_skip_relocation, monterey:       "c7df4ab43637b0a263dd618811ffcc676e081aff7614e2803d4cf124cc27d0a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7df4ab43637b0a263dd618811ffcc676e081aff7614e2803d4cf124cc27d0a3"
    sha256 cellar: :any_skip_relocation, catalina:       "c7df4ab43637b0a263dd618811ffcc676e081aff7614e2803d4cf124cc27d0a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f74e0c26b6f2374bb0ab7e4a9d08388cf11ab4e82eebd6fdbfb5177db863241c"
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

    generate_completions_from_executable(bin/"vela", "completion", shells: [:bash, :zsh], base_name: "vela")
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
