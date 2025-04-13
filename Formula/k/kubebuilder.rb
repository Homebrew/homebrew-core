class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v4.5.2",
      revision: "7c707052daa2e8bd51f47548c02710b1f1f7a77e"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4eb39ab13ebaeb91d38858d972533967057123f05b11ac9c1471777d94039a97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4eb39ab13ebaeb91d38858d972533967057123f05b11ac9c1471777d94039a97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4eb39ab13ebaeb91d38858d972533967057123f05b11ac9c1471777d94039a97"
    sha256 cellar: :any_skip_relocation, sonoma:        "12b4ea064e71982f7830f3cd1cf73c7281a52b060abe2d383520d9a6953edd8f"
    sha256 cellar: :any_skip_relocation, ventura:       "12b4ea064e71982f7830f3cd1cf73c7281a52b060abe2d383520d9a6953edd8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18f0e43e72941720bf85430c3e8781a908dbb898d4dd937ee95d270896000cb5"
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
