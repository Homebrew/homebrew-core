class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.9.11",
      revision: "89177805558583b60daefd6db4374837765a2cc1"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e83588e5ff50d564b43a22ca5f6c86b6084f3ce5b5696012bb4c7bff829a0c6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e83588e5ff50d564b43a22ca5f6c86b6084f3ce5b5696012bb4c7bff829a0c6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e83588e5ff50d564b43a22ca5f6c86b6084f3ce5b5696012bb4c7bff829a0c6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfc42c81c3b3a71b27205dbc0ae274446719c8fafabfbd2248b76b884134f9cf"
    sha256 cellar: :any_skip_relocation, ventura:        "bfc42c81c3b3a71b27205dbc0ae274446719c8fafabfbd2248b76b884134f9cf"
    sha256 cellar: :any_skip_relocation, monterey:       "bfc42c81c3b3a71b27205dbc0ae274446719c8fafabfbd2248b76b884134f9cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee01afbbadc0b54baed66cee799163c7ea76703e65895392f7f0b823fb47c8a9"
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
