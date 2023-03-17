class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.7.6",
      revision: "e4cd1ffd1d4006fd297aeb68a37c5f3a6ec09a4f"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c1de11ffbfe0b6e1131951da1a8c901fd83facc01b43eab845be8b790fc9ff1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c1de11ffbfe0b6e1131951da1a8c901fd83facc01b43eab845be8b790fc9ff1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c1de11ffbfe0b6e1131951da1a8c901fd83facc01b43eab845be8b790fc9ff1"
    sha256 cellar: :any_skip_relocation, ventura:        "912cd4a760f2d39acb1cfe3b5020f484d71bc8be43fe63b144c80b0a3e1ed1b9"
    sha256 cellar: :any_skip_relocation, monterey:       "912cd4a760f2d39acb1cfe3b5020f484d71bc8be43fe63b144c80b0a3e1ed1b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "912cd4a760f2d39acb1cfe3b5020f484d71bc8be43fe63b144c80b0a3e1ed1b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df1520589512e56646c2b9aedad8e654231b48277e741682657b9409640be296"
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
