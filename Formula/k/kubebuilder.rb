class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v4.9.0",
      revision: "5e331e74c7a25c8e8fc0d9d5c33c319b7268f395"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65052e7ffd6ff1c4f47fd67a7ef293612c2c92e2c9af0dacf46138c619b35691"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65052e7ffd6ff1c4f47fd67a7ef293612c2c92e2c9af0dacf46138c619b35691"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65052e7ffd6ff1c4f47fd67a7ef293612c2c92e2c9af0dacf46138c619b35691"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ab6fb953a944a65c051a42eaf9c7b9fb66cf546d5415baf0339a738fe5dbb77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4822f91df253aff1214200eec5b97c6e57dbeb84a9d8f473158a0994d77a475"
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
