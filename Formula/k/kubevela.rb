class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.10.7",
      revision: "a2fe0b9fdce6d6dda03388dd8acb235352de39ba"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80cfb7d28a2b4e674a9de69b463fec9c8d1bba75510fe10f62aeb42257dd92fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80cfb7d28a2b4e674a9de69b463fec9c8d1bba75510fe10f62aeb42257dd92fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80cfb7d28a2b4e674a9de69b463fec9c8d1bba75510fe10f62aeb42257dd92fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "86adcaafbff254bf6ac1230e8011ddea914eab4e618527e0e179de5977d18b2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "128706b2eb0a5eb1acd8ee2c252dd0b96f843d344ac044684ffab9973bc3933b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93e5c3ec0e3af9e22c8a7c2bea483545a1c8f7c49119b2949096346c68819c26"
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

    generate_completions_from_executable(bin/"vela", "completion", shells: [:bash, :zsh])
  end

  test do
    # Should error out as vela up need kubeconfig
    status_output = shell_output("#{bin}/vela up 2>&1", 1)
    assert_match "error: either app name or file should be set", status_output

    (testpath/"kube-config").write <<~YAML
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
    YAML

    ENV["KUBECONFIG"] = testpath/"kube-config"
    version_output = shell_output("#{bin}/vela version 2>&1")
    assert_match "Version: #{version}", version_output
  end
end
