class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v4.15.0",
      revision: "034c380389c00396878da8b388d42b17d55f8dd8"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f2312cde463d7b8ac93f9457e117920d7382563db61ae5041f62b19f6cf0acc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f2312cde463d7b8ac93f9457e117920d7382563db61ae5041f62b19f6cf0acc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f2312cde463d7b8ac93f9457e117920d7382563db61ae5041f62b19f6cf0acc"
    sha256 cellar: :any_skip_relocation, sonoma:        "16d1fffa9b551122dc5fc341d8304be64e025e751784935bbf841a58d5c90245"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "840472fe9e0b70daea26f42992ea8f805546d84c06a484a326dd9198427f32f3"
    sha256 cellar: :any,                 x86_64_linux:  "ae2d6b29ff0bea73d77cd1b0b1eabe6f5145165011202541a4466267283c0f7e"
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
