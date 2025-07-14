class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v4.7.0",
      revision: "cf5dbb3a7494a3043ac11f341e385e044e163c66"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "881ffbe893396446696c52ef9e087a8d42328f83849462ec2441d4d838bc7a5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "881ffbe893396446696c52ef9e087a8d42328f83849462ec2441d4d838bc7a5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "881ffbe893396446696c52ef9e087a8d42328f83849462ec2441d4d838bc7a5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f7531b69a930738cbab5148122eec4601b853ce05b491be5cf21c94bfe88f8b"
    sha256 cellar: :any_skip_relocation, ventura:       "7f7531b69a930738cbab5148122eec4601b853ce05b491be5cf21c94bfe88f8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cdf3b77b8bffa9aed95a3078ba0756323810a34fbf0d824ab7b6ad6297a381a"
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
