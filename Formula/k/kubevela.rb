class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.9.10",
      revision: "24756fc507665bff5cbd6108e63391a3e50fa96b"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "423d38fae451af44d41d88e7776e53bfaa1920ebd16fb5f9e05770012a007802"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "423d38fae451af44d41d88e7776e53bfaa1920ebd16fb5f9e05770012a007802"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "423d38fae451af44d41d88e7776e53bfaa1920ebd16fb5f9e05770012a007802"
    sha256 cellar: :any_skip_relocation, sonoma:         "4cc4a7b5e8dca2a2ca1f1e9d38784177d20c2378d60aa89e4169b6b941fc2ee0"
    sha256 cellar: :any_skip_relocation, ventura:        "4cc4a7b5e8dca2a2ca1f1e9d38784177d20c2378d60aa89e4169b6b941fc2ee0"
    sha256 cellar: :any_skip_relocation, monterey:       "4cc4a7b5e8dca2a2ca1f1e9d38784177d20c2378d60aa89e4169b6b941fc2ee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85bfc7ec3604d40e8cddec924b4b1ea1d657d467a453df5dceec8cbd0d3ae51f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/oam-dev/kubevela/version.VelaVersion=#{version}
      -X github.com/oam-dev/kubevela/version.GitRevision=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(output: bin/"vela", ldflags:), "./references/cmd/cli"

    generate_completions_from_executable(bin/"vela", "completion", shells: [:bash, :zsh], base_name: "vela")
  end

  test do
    # Should error out as vela up need kubeconfig
    status_output = shell_output("#{bin}/vela up 2>&1", 1)
    assert_match "error: either app name or file should be set", status_output

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
