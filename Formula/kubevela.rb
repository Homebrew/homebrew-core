class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.7.2",
      revision: "4b88cd201e487d1c6a2085489c54905b7f11d741"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f6e8e7e206c38f08ac43ecfdb751c9a93695c532c1b626bcd62bb90a8fa1d16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f6e8e7e206c38f08ac43ecfdb751c9a93695c532c1b626bcd62bb90a8fa1d16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f6e8e7e206c38f08ac43ecfdb751c9a93695c532c1b626bcd62bb90a8fa1d16"
    sha256 cellar: :any_skip_relocation, ventura:        "b1a64833a0abf8f44c75b3528a6e0c00e175a12ccc8447e9174d0f6b185d7a30"
    sha256 cellar: :any_skip_relocation, monterey:       "b1a64833a0abf8f44c75b3528a6e0c00e175a12ccc8447e9174d0f6b185d7a30"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1a64833a0abf8f44c75b3528a6e0c00e175a12ccc8447e9174d0f6b185d7a30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cc1a7163ece4ca204dbd72e3de18d5abe7e89ec3f3df2114059780d2d19e89d"
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
