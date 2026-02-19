class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v4.12.0",
      revision: "94434cdf622a00d8a8a50f53a2ab36b3059c8830"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31c17ef1076c83cfa645a7cb9f10477a5ec7d9e0f5a0054a51c9002dc0d01e9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31c17ef1076c83cfa645a7cb9f10477a5ec7d9e0f5a0054a51c9002dc0d01e9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31c17ef1076c83cfa645a7cb9f10477a5ec7d9e0f5a0054a51c9002dc0d01e9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "10682d49e423419e5ee4d14de10469dd89fbcdf8193860db217eebe869de4503"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f53928dbc8f3a114485b52677d3aad1f4f996080fec1f5df96edaf183ffda9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "826782bee19663a11396ce0d17e9fcc60b019749b67b17e56cde5164f6898e63"
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
