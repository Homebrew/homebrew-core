class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v4.6.0",
      revision: "cd90bd82a2d692fbf63ba0231699e2e3dc0b6a08"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a65bc2936b3229b9c8b72004778f281d988dd5b596770741445c778b014ad813"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a65bc2936b3229b9c8b72004778f281d988dd5b596770741445c778b014ad813"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a65bc2936b3229b9c8b72004778f281d988dd5b596770741445c778b014ad813"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8439d5fd68fde7a68dd04e8c9dea35fc7d85634643c286f504fc0cca32dabae"
    sha256 cellar: :any_skip_relocation, ventura:       "a8439d5fd68fde7a68dd04e8c9dea35fc7d85634643c286f504fc0cca32dabae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21ea9fe1b518f8bea3516ac7030bd9fb558564a0d983fb296264b7b80d476497"
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
