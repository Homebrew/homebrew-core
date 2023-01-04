class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.6.6",
      revision: "b24b52b65129e25bfdeb87026a500e0b50541a64"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c2ef5e8dde960139a307d2c8551247a02397fe7bf26d5dc33e043c62fa426b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c2ef5e8dde960139a307d2c8551247a02397fe7bf26d5dc33e043c62fa426b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c2ef5e8dde960139a307d2c8551247a02397fe7bf26d5dc33e043c62fa426b1"
    sha256 cellar: :any_skip_relocation, ventura:        "4e6f654635bbd0e464303d75e647e0d18cde88d6e71cb06829973c466268985a"
    sha256 cellar: :any_skip_relocation, monterey:       "4e6f654635bbd0e464303d75e647e0d18cde88d6e71cb06829973c466268985a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e6f654635bbd0e464303d75e647e0d18cde88d6e71cb06829973c466268985a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22d45566474011ea34567519864e34f0ae9ad5d9bb71fe63d3549bbf922f3f0d"
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
