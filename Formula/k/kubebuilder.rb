class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v4.11.0",
      revision: "5391809864a7549757a1c9753530335563c0c09a"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ee9aaa34abfcb904d19a3a3dfdf1ab5afa25199bb249e5aac1abffb15d90d93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ee9aaa34abfcb904d19a3a3dfdf1ab5afa25199bb249e5aac1abffb15d90d93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ee9aaa34abfcb904d19a3a3dfdf1ab5afa25199bb249e5aac1abffb15d90d93"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcf69897304c06e97a8343eb9fe3cdaa3d02d08a8d82d56e15fe2f235248802e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a2f9b15a6dfbe251b9335e04b05f94a083ae288774c22674ed74d9820246522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34df69f08ea5a5d5a183cb2d9956050c304836d75a0c1bd2af2e855854340e55"
  end

  depends_on "go"

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp

    ldflags = %W[
      -s -w
      -X sigs.k8s.io/kubebuilder/v4/cmd.kubeBuilderVersion=#{version}
      -X sigs.k8s.io/kubebuilder/v4/cmd.goos=#{goos}
      -X sigs.k8s.io/kubebuilder/v4/cmd.goarch=#{goarch}
      -X sigs.k8s.io/kubebuilder/v4/cmd.gitCommit=#{Utils.git_head}
      -X sigs.k8s.io/kubebuilder/v4/cmd.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubebuilder", shell_parameter_format: :cobra)
  end

  test do
    mkdir "test" do
      system "go", "mod", "init", "example.com"
      system bin/"kubebuilder", "init",
                 "--plugins", "go.kubebuilder.io/v4",
                 "--project-version", "3",
                 "--skip-go-version-check"
    end

    assert_match <<~YAML, (testpath/"test/PROJECT").read
      domain: my.domain
      layout:
      - go.kubebuilder.io/v4
      projectName: test
      repo: example.com
      version: "3"
    YAML

    assert_match version.to_s, shell_output("#{bin}/kubebuilder version")
  end
end
