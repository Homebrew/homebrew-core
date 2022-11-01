class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.6.0",
      revision: "4b4e4f8530fe9ecac9e7f3b7bf64d8cb9c792c1e"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cc7a8548b29a4697f7e0c825c2f1e5098c396ee77b7c9d670f57a7b4b89f546"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cc7a8548b29a4697f7e0c825c2f1e5098c396ee77b7c9d670f57a7b4b89f546"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3cc7a8548b29a4697f7e0c825c2f1e5098c396ee77b7c9d670f57a7b4b89f546"
    sha256 cellar: :any_skip_relocation, monterey:       "9541b86c8e3e36e62274317d6677dad44cea0dba920791f42c0c93348c09e3cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "9541b86c8e3e36e62274317d6677dad44cea0dba920791f42c0c93348c09e3cc"
    sha256 cellar: :any_skip_relocation, catalina:       "9541b86c8e3e36e62274317d6677dad44cea0dba920791f42c0c93348c09e3cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd099e08a1d0b50006a3c2970cf3832c4c8e14294340eecf384cd46ce9ba1bde"
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
