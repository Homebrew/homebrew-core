class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v4.16.0",
      revision: "4d01fcdf146e4d832fc973ef95684a00bcf0f0c0"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b9426683dc0f8201c4548f901ded21b2ec737297a30e82fafb13b20037ccb144"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b9426683dc0f8201c4548f901ded21b2ec737297a30e82fafb13b20037ccb144"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b9426683dc0f8201c4548f901ded21b2ec737297a30e82fafb13b20037ccb144"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b9426683dc0f8201c4548f901ded21b2ec737297a30e82fafb13b20037ccb144"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d727955024ca9f49ae7129a31e29b314f2c8daa48aafaefa7f5c18c4e4a6c90a"
    sha256 cellar: :any,                 x86_64_linux:      "b73825289bca4d709644ee29a04d390b26d707b94d7c9b5f9f006325565c1efb"
  end

  depends_on "go"

  def install
    goos = Utils.safe_popen_read("#{formula_opt_bin("go")}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{formula_opt_bin("go")}/go", "env", "GOARCH").chomp

    ldflags = %W[
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
