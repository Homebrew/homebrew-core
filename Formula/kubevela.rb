class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/kubevela/kubevela.git",
      tag:      "v1.6.5",
      revision: "18639ccbae6062929e9f2cabc19795678f22f007"
  license "Apache-2.0"
  head "https://github.com/kubevela/kubevela.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c31be87f86cd24e4b7ea9a1937fa59853041c39a07fb65117d1c0d965c01b64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c31be87f86cd24e4b7ea9a1937fa59853041c39a07fb65117d1c0d965c01b64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c31be87f86cd24e4b7ea9a1937fa59853041c39a07fb65117d1c0d965c01b64"
    sha256 cellar: :any_skip_relocation, ventura:        "a336a17f129ddb6f6b936ae69f966b62bca2594876018a41289e480bddd43c64"
    sha256 cellar: :any_skip_relocation, monterey:       "a336a17f129ddb6f6b936ae69f966b62bca2594876018a41289e480bddd43c64"
    sha256 cellar: :any_skip_relocation, big_sur:        "a336a17f129ddb6f6b936ae69f966b62bca2594876018a41289e480bddd43c64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "799ea28c23335c7d631567f4881fd67eb546fedaceecd50168785130b5aed71d"
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
