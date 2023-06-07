class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.8.2",
      revision: "360f69bea54cb0d15814ba14ea71dacc5f3eba97"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "110a456d8638cfa2000cab981ba8357f5f83d82e2a1d08108c3ea85ce2f96209"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "110a456d8638cfa2000cab981ba8357f5f83d82e2a1d08108c3ea85ce2f96209"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "110a456d8638cfa2000cab981ba8357f5f83d82e2a1d08108c3ea85ce2f96209"
    sha256 cellar: :any_skip_relocation, ventura:        "d3a674b3e52c71f839a436d4432cde6f5ba95857dc4bc32106821bf52f0354bb"
    sha256 cellar: :any_skip_relocation, monterey:       "d3a674b3e52c71f839a436d4432cde6f5ba95857dc4bc32106821bf52f0354bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3a674b3e52c71f839a436d4432cde6f5ba95857dc4bc32106821bf52f0354bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f9e33a675371e7670236860ab2eb7ff6706cd28d0753416872107616afe9e68"
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
