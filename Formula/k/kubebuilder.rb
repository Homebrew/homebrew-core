class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v4.10.1",
      revision: "8bce950e46b914d54c872da25500b8c27b6c05e8"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12ebb56f847ad9acba38ec8707b0e4127207d305de8ed108679d0cbc348e3fdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12ebb56f847ad9acba38ec8707b0e4127207d305de8ed108679d0cbc348e3fdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12ebb56f847ad9acba38ec8707b0e4127207d305de8ed108679d0cbc348e3fdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a1b98bbd0207d0e2aadacac616a535cad6853a76299a291041ad258eb095cf9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78af0f76b525a9313733ca38692d5bfb122b51cc540037ba45d6579df14137be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e24bcf8fc4d65e14803f9a704c17b9e036880b042290491b2c8facc5639b71d"
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

    generate_completions_from_executable(bin/"kubebuilder", "completion")
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
