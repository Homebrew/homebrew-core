class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v4.13.1",
      revision: "1c484f91df846970e72b0344cca86c5c98845ea8"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "819c0fbc7476f3c443111102cccf664c37607c97aefbf7580f128366c2136ac7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "819c0fbc7476f3c443111102cccf664c37607c97aefbf7580f128366c2136ac7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "819c0fbc7476f3c443111102cccf664c37607c97aefbf7580f128366c2136ac7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dcfe0d640aaebb163afc835c773c45f674931bda8e355a3a0131b83df4a6b45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd910b0c7db5619bfc94acdce4c544727b8e0a40dc50ccf1329a9ce8f8bab287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3939ef1b9c0f7f86458258abf6a9c3eb60019cbe33b1a3ea51a3f1b4c43affe1"
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
