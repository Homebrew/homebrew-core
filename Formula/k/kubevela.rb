class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.10.0",
      revision: "bc15e5b3592467db3d71f166835eb05540af2abe"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0111881b206b492fc00c18b52eb052d6c3ea87226a2ea829036c9b347f15e6f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0111881b206b492fc00c18b52eb052d6c3ea87226a2ea829036c9b347f15e6f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0111881b206b492fc00c18b52eb052d6c3ea87226a2ea829036c9b347f15e6f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "49287164da7387e4c3615dcd42e041eb064aee9708c19c23558a4aa6e75b6012"
    sha256 cellar: :any_skip_relocation, ventura:       "49287164da7387e4c3615dcd42e041eb064aee9708c19c23558a4aa6e75b6012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b69159e6f9e4e93a554fdd8dce35f179acc1c0e23ccd3532618bdc9b2e6cdafe"
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
