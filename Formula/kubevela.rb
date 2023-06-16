class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.9.0",
      revision: "da3618ad2743713f38508fe28fef1b2d34810034"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6be5b0066f10fbaa1082a43adca2adf975942447b3dae953447881eeca696a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6be5b0066f10fbaa1082a43adca2adf975942447b3dae953447881eeca696a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6be5b0066f10fbaa1082a43adca2adf975942447b3dae953447881eeca696a7"
    sha256 cellar: :any_skip_relocation, ventura:        "161010bfe32df6fcb444b34371490b613885d0715e1d441e2ec45cfc1cbeb33a"
    sha256 cellar: :any_skip_relocation, monterey:       "161010bfe32df6fcb444b34371490b613885d0715e1d441e2ec45cfc1cbeb33a"
    sha256 cellar: :any_skip_relocation, big_sur:        "161010bfe32df6fcb444b34371490b613885d0715e1d441e2ec45cfc1cbeb33a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1497a9767d6686fdb3a470916c90c9795308f1acadb32fa85aeabc621f625538"
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
