class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.5.6",
      revision: "4c525f8e5d51358551418d49e64ef9fdd2885367"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a68be26f03414fd5c1655c2218213a9e058ecdf6d16990c5ae69a059f969f9e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a68be26f03414fd5c1655c2218213a9e058ecdf6d16990c5ae69a059f969f9e"
    sha256 cellar: :any_skip_relocation, monterey:       "fa6bc018a54ef360cb4374c261f5bbd61b3022d1295d55b85ff5aed8fd6bf0a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa6bc018a54ef360cb4374c261f5bbd61b3022d1295d55b85ff5aed8fd6bf0a4"
    sha256 cellar: :any_skip_relocation, catalina:       "fa6bc018a54ef360cb4374c261f5bbd61b3022d1295d55b85ff5aed8fd6bf0a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "631ac74012b16fa9a7aafd2b825dbb34a73f2faaefeded10d4bfe74cc02fc17c"
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
