class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.6.1",
      revision: "f0e3304c1764f959b4897f6785c94497daf19cf4"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ab3a36d2dfc06419a58f4c5cc6f3288b095ec4d9f82d704338afffd7ac97dec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ab3a36d2dfc06419a58f4c5cc6f3288b095ec4d9f82d704338afffd7ac97dec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ab3a36d2dfc06419a58f4c5cc6f3288b095ec4d9f82d704338afffd7ac97dec"
    sha256 cellar: :any_skip_relocation, monterey:       "5eebde93de56f3564cc8f095100b3b9fb7a50818dc7e690af1c8d1ee24b9f8e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5eebde93de56f3564cc8f095100b3b9fb7a50818dc7e690af1c8d1ee24b9f8e6"
    sha256 cellar: :any_skip_relocation, catalina:       "5eebde93de56f3564cc8f095100b3b9fb7a50818dc7e690af1c8d1ee24b9f8e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3fed719eca5672582819bcf04f03e9544f9edd0dddf709ac061821c5d82f9fb"
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
