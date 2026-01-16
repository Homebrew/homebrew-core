class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v4.10.1",
      revision: "8bce950e46b914d54c872da25500b8c27b6c05e8"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "491a6bd03409c9c3c3a7aba37713742dfff02ea98a867b601a8946f85d452c25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "491a6bd03409c9c3c3a7aba37713742dfff02ea98a867b601a8946f85d452c25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "491a6bd03409c9c3c3a7aba37713742dfff02ea98a867b601a8946f85d452c25"
    sha256 cellar: :any_skip_relocation, sonoma:        "68ca4eccbb5f2fdcba3703eae8321406cdaa108825cf7e91a29b62e72034938c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77b1473ec59a4eae5b98c727ce090582cf494a2278b82a55a5c9568d7e86b9c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f735e9f9ff5ac7a383b9d53237744a10eb19ee582f2e0e2958b0a467b21471b1"
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
